require 'logger'

  def log_to_file(file_name)
    path = "logger"
    FileUtils.mkdir_p(path)
    log_path = File.join(path, "#{file_name}.log")
  
    logger = Logger.new(log_path)
    logger.datetime_format = "%d %b %Y %H:%M:%S" # Format: "21 Feb 2025 10:00:16"
  
    # Custom formatter to remove the "I," at the beginning
    logger.formatter = proc do |severity, datetime, _progname, msg|
      process_id = Process.pid
      "[#{datetime.strftime(logger.datetime_format)} ##{process_id}] #{severity} -- : #{msg}\n"
    end
  
    logger
  end

  def log_to_console(log_message, level = :info)
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger.datetime_format = "%d %b %Y %H:%M:%S" # Format: "21 Feb 2025 10:00:16"
  
    # Custom formatter to remove the "I," at the beginning
    logger.formatter = proc do |severity, datetime, _progname, msg|
      process_id = Process.pid
      "[#{datetime.strftime(logger.datetime_format)} ##{process_id}] #{severity} -- : #{msg}\n"
    end
  
    case level
    when :info
      logger.info(log_message)
    when :error
      logger.error(log_message)
    else
      logger.debug(log_message)
    end
  end
