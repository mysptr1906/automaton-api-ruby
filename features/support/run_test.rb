require_relative "constants"
require_relative "logger"

class RunTest
  class << self
    def run_test(tests)
      valid_prefix = %w[feature: json: tags:]

      tests.split(",").each do |test|
        case test.downcase
        when /^#{valid_prefix[0]}/
          feature_file = test.gsub(/^#{valid_prefix[0]}/, "")
          puts "Running feature: #{feature_file}"
          run_by_feature(feature_file)
        when /^#{valid_prefix[1]}/
          test_set = test.gsub(/^#{valid_prefix[1]}/, "")
          puts "Running test set: #{test_set}"
          run_by_json(test_set)
        when /^#{valid_prefix[2]}/
          test_set = test.gsub(/^#{valid_prefix[2]}/, "")
          puts "Running test set by tags: #{test_set}"
          run_by_tags(test_set)
        else
          raise "'#{test}' is not a valid test set prefix. Valid prefixes are: #{valid_prefix.join(', ')}"
        end
      end
    end

    private

    def run_by_feature(feature_file)
      feature_path = Constants::FEATURE_FILE_FOLDER_PATH
      
      # Generate the pattern with **/ to check nested directories
      pattern = "#{feature_path}/**/#{feature_file}.feature"
      puts "Searching for pattern: #{pattern}"

      if Dir.glob(pattern).any?
        # If file exists with subdirectories, go deeper (resolve the actual path)
        feature_path = Dir.glob("#{feature_path}/**/#{feature_file}.feature").first
      else
        # If file is not found, search without subdirectories
        feature_path = "#{feature_path}/**/#{feature_file}.feature"
      end

      # Log what is being run
      log_to_console("Running all scenarios for feature: '#{feature_file}'")

      system("cucumber #{feature_path} --tags '@API and @Automated'")
    end

    def run_by_json(test_set_name)
      feature_folder_path = Constants::FEATURE_FILE_FOLDER_PATH
      test_set_folder_path = Constants::TEST_SET_JSON_FOLDER_PATH

      read_test_set_json = JSON.parse(File.read("#{test_set_folder_path}/#{test_set_name}.json"))
      default_tags = Constants::TAG_MANDATORY_RUN_TEST

      read_test_set_json.each do |entry|
        feature_name = entry["feature"]
        feature_path = File.join(feature_folder_path, "#{feature_name}.feature")

        if entry.key?("tests")
          log_to_console("Tests feature '#{feature_name}':")
          entry["tests"].each do |test|
            if test =~ /^@/
              system("cucumber #{feature_path} --tags '#{default_tags} and #{test}'")
            else
              test_name = escape_special_chars(test)
              log_to_console("Running test: '#{test_name}'")
              system("cucumber #{feature_path} --name '#{test_name}$' --tags '#{default_tags}'")
            end
          end
        elsif entry.key?("excludes")
          exclude_scenario_name(
            extract_scenario_names(feature_path),
            entry["excludes"]
          ).each do |scenario|
            scenario_name = escape_special_chars(scenario)
            log_to_console("Running test: '#{scenario_name}'")
            system("cucumber #{feature_path} --name '#{scenario_name}$' --tags '#{default_tags}'")
          end
        else
          log_to_console("Running all scenarios for feature: '#{feature_name}'")
          system("cucumber #{feature_path} --tags '#{default_tags}'")
        end
      end
    end

    def run_by_tags(tags)
      test_tags = "#{Constants::TAG_MANDATORY_RUN_TEST} and #{tags}"
      log_to_console("Running all scenarios with tags: '#{test_tags}'")
      system("cucumber --tags '#{test_tags}'")
    end

    # Escapes special characters in a string that could interfere with regular expressions
    # or shell commands, such as brackets, parentheses, and other symbols.
    #
    # @param [String] string The string in which special characters need to be escaped.
    # @return [String] The string with special characters escaped.
    def escape_special_chars(string)
      string.gsub(/([\[\]()?.])/) { |match| "\\#{match}" }
    end

    # Method to exclude specific scenario names from a list of scenario names
    # @param scenario_names [Array<String>] - Array of scenario names
    # @param scenario_excludes [Array<String>] - Array of scenario names to exclude
    # @return [Array<String>] - The modified scenario_names array with excluded names removed
    def exclude_scenario_name(scenario_names, scenario_excludes)
      # Remove any scenario name from scenario_names that is included in scenario_excludes
      scenario_names.delete_if { |name| scenario_excludes.include?(name) }
    end

    # This method extracts the names of all scenarios from a given Cucumber feature file.
    # It reads the content of the file located at 'file_path' and scans for lines that start with 'Scenario' or 'Scenario Outline'.
    # The method then removes the prefixes ('Scenario Outline: ' or 'Scenario: ') and returns an array of clean scenario names.
    def extract_scenario_names(file_path_pattern)
      Dir.glob(file_path_pattern).flat_map do |file_path|
        File.read(file_path).scan(/Scenario:.*|Scenario Outline:.*/).map { |s| s.gsub(/Scenario Outline: |Scenario: /, "") }
      end
    end
  end
end