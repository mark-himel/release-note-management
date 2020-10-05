require 'logger' unless defined?(Logger)

module ErrorReporter
  def self.logger
    @logger ||= default_logger
  end

  def self.logger=(value)
    @logger = value
  end

  def self.reporters
    @reporters || []
  end

  def self.reporters=(value)
    @reporters = value
  end

  def self.call(error)
    error(error)
  end

  def self.critical(error, meta_data = nil)
    log(:fatal, error)
    report(:critical, error, meta_data)
  end

  def self.fatal(error, meta_data = nil)
    log(:fatal, error)
    report(:critical, error, meta_data)
  end

  def self.error(error, meta_data = nil)
    log_and_report(:error, error, meta_data)
  end

  def self.warn(error, meta_data = nil)
    log_and_report(:warn, error, meta_data)
  end

  def self.info(info, meta_data = nil)
    log_and_report(:info, info, meta_data)
  end

  def self.debug(info, meta_data = nil)
    log_and_report(:debug, info, meta_data)
  end

  def self.log_and_report(type, error, meta_data = nil)
    log(type, error)
    report(type, error, meta_data)
  end

  def self.log(type, error)
    logger.public_send(type, error.inspect)
    logger.public_send(type, error.backtrace.join("\n"))
  end

  # :reek:ManualDispatch
  def self.report(type, error, meta_data = nil)
    reporters.each do |reporter|
      if reporter.method(type).arity < 0 && meta_data
        reporter.public_send(type, error, meta_data)
      else
        reporter.public_send(type, error)
      end
    end
  end

  def self.default_logger
    ::Logger.new(STDOUT)
  end
end
