module Constants
  FEATURE_FILE_FOLDER_PATH = "#{Dir.pwd}/features/scenarios".freeze
  TEST_SET_JSON_FOLDER_PATH = "#{Dir.pwd}/features/test_sets".freeze
  TAG_MANDATORY_RUN_TEST = "@API and @Automated".freeze
  TEST_SETS = ENV["TEST_SETS"]
end