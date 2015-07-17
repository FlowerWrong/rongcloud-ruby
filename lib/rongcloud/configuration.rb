require 'active_support/configurable'

module Rongcloud
  # Configures global settings for Rongcloud
  #   Rongcloud.configure do |config|
  #     config.app_key = 10
  #   end
  def self.configure(&block)
    yield @config ||= Rongcloud::Configuration.new
  end

  # Global settings for Rongcloud
  def self.config
    @config
  end

  class Configuration  #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :app_key
  end

  # this is ugly. why can't we pass the default value to config_accessor...?
  configure do |config|
    config.app_key = ''
  end
end
