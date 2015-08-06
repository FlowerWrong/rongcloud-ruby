require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Rongcloud::Configuration do
  before(:all) do
    RONGCLOUD_CONFIG = YAML.load(File.open(Rongcloud.root + '/config.yml')).symbolize_keys
    @deault_config = RONGCLOUD_CONFIG[:rongcloud].symbolize_keys
  end

  it 'should setup config' do
    Rongcloud.configure do |config|
      config.app_key = @deault_config[:app_key]
      config.app_secret = @deault_config[:app_secret]
      config.host = @deault_config[:host]
      config.log_file = @deault_config[:log_file]
      config.log_level = @deault_config[:log_level].to_sym
    end
    expect(Rongcloud.config.app_key).to eql(@deault_config[:app_key])
  end
end
