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

  it 'should refresh someone info' do
    res_hash = @service.refresh_user('yang', 'yang')
    expect(res_hash[:code]).to eq(200)
  end

  it 'should check user online status' do
    res_hash = @service.online_status('yang')
    expect(res_hash[:code]).to eq(200)
    expect(res_hash[:status]).to eq('0')
  end

  it 'should block user' do
    res_hash = @service.block_user('yang', 180)
    expect(res_hash[:code]).to eq(200)
  end

  it 'should get block users' do
    res_hash = @service.block_users
    expect(res_hash[:code]).to eq(200)
  end

  it 'should unblock a user' do
    res_hash = @service.unblock_user('yang')
    expect(res_hash[:code]).to eq(200)
  end


  ## 用户黑名单服务
  context 'blacklist' do
    it 'should add a user to blacklist' do
      res_hash = @service.get_token('yang_two', 'yangyang')
      res_hash = @service.add_black('yang', 'yang_two')
      expect(res_hash[:code]).to eq(200)
    end

    it 'should get someone blacklist' do
      res_hash = @service.blacklist('yang')
      expect(res_hash[:code]).to eq(200)
      expect(res_hash[:users].include?('yang_two')).to eq(true)
    end

    it 'should remove someone form user blacklist' do
      res_hash = @service.remove_black('yang', 'yang_two')
      expect(res_hash[:code]).to eq(200)
    end
  end

  ## 消息发送服务
  context 'message' do
    it 'should send a private msg from yang to yang_two' do
      content = { content: 'hello', extra: 'helloExtra'}
      res_hash = @service.send_private_msg('yang', 'yang_two', 'RC:TxtMsg', content)
      expect(res_hash[:code]).to eq(200)
    end

    it 'should send a template msg' do
      pending 'Need to test send a template msg'
      fail
    end

    it 'should send a sys msg' do
      content = { content: 'hello', extra: 'helloExtra'}
      res_hash = @service.send_sys_msg('yang', 'yang_two', 'RC:TxtMsg', content)
      expect(res_hash[:code]).to eq(200)
    end

    it 'should send a group msg' do
      pending 'Need to test send a group msg'
      fail
    end

    it 'should send a chatroom msg' do
      pending 'Need to test send a chatroom msg'
      fail
    end

    it 'should send a broadcast msg' do
      content = { content: 'hello', extra: 'helloExtra'}
      res_hash = @service.send_broadcast_msg('yang', 'RC:TxtMsg', content)
      expect(res_hash[:code]).to eq(200)
    end
  end

  ## 同步消息
  context 'sync msg' do

  end
end
