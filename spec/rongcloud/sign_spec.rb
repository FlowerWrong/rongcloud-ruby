require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Rongcloud::Sign do
  before(:all) do
    RONGCLOUD_CONFIG = YAML.load(File.open(Rongcloud.root + '/config.yml')).symbolize_keys
    @deault_config = RONGCLOUD_CONFIG[:rongcloud].symbolize_keys
    Rongcloud.configure do |config|
      config.app_key = @deault_config[:app_key]
      config.app_secret = @deault_config[:app_secret]
      config.host = @deault_config[:host]
    end
  end

  it 'should generate a sign header' do
    app_key = @deault_config[:app_key]
    header = Rongcloud::Sign.sign_headers(app_key, @deault_config[:app_secret])
    expect(header['App-Key']).to eq(app_key)
  end
end
