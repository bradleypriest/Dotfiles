# Enable SQL logging when working in an Active Record console.
def enable_logging!
  return unless defined?(ActiveRecord::Base)

  require "logger"
  ActiveRecord::Base.logger = Logger.new($stdout)
end
