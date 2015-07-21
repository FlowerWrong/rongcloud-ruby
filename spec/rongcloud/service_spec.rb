require 'spec_helper'
require 'yaml'
require 'active_support/core_ext/hash/keys'

describe Rongcloud::Service do
  before(:all) do
    RONGCLOUD_CONFIG = YAML.load(File.open(Rongcloud.root + '/config.yml')).symbolize_keys
    @deault_config = RONGCLOUD_CONFIG[:rongcloud].symbolize_keys
    Rongcloud.configure do |config|
      config.app_key = @deault_config[:app_key]
      config.app_secret = @deault_config[:app_secret]
      config.host = @deault_config[:host]
    end
    @service = Rongcloud::Service.new
  end

  it 'should get token of yang' do
    res_hash = @service.get_token('yang', 'yangfusheng', 'https://ruby-china-files.b0.upaiyun.com/user/big_avatar/9442.jpg')
    expect(res_hash[:code]).to eq(200)
    expect(res_hash[:token].size).to eq(88)
    expect(res_hash[:userId]).to eq('yang')
  end
end
