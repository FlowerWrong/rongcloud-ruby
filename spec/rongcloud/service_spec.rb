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
    it 'should sync msg' do
      pending 'Need to test sync msg'
      fail
    end
  end

  ## 消息历史记录服务
  context 'msg history download and delete' do
    it 'should download msg history of date' do
      pending 'Need to test download msg history of date'
      fail
    end

    it 'should delete msg history of date' do
      pending 'Need to test delete msg history of date'
      fail
    end
  end

  ## 群组服务
  context 'group' do
    it 'should create a group' do
      res_hash = @service.create_group('yang', 'testgroup', 'a_test_demo_group')
      expect(res_hash[:code]).to eq(200)
    end

    it 'should add user to a group' do
      res_hash = @service.add_group('yang_two', 'testgroup', 'a_test_demo_group')
      expect(res_hash[:code]).to eq(200)
    end

    it 'should refresh a group' do
      res_hash = @service.refresh_group('testgroup', 'a_test_demo_group_refresh')
      expect(res_hash[:code]).to eq(200)
    end

    it 'should sync a group' do
      groups = { 'testgroup' => 'a_test_demo_group_refresh' }
      res_hash = @service.sync_group('yang', groups)
      expect(res_hash[:code]).to eq(200)
    end

    it 'should quit a group' do
      res_hash = @service.out_group('yang_two', 'testgroup')
      expect(res_hash[:code]).to eq(200)
    end

    it 'should dismiss a group' do
      res_hash = @service.dismiss_group('yang_two', 'testgroup')
      expect(res_hash[:code]).to eq(200)
    end
  end

  ## 聊天室服务
  context 'chatroom' do
    it 'should create a chatroom' do
      chatroom = { 'demo' => 'demo', 'testchat' => 'testchat' }
      res_hash = @service.create_chatroom(chatroom)
      expect(res_hash[:code]).to eq(200)
    end

    it 'should query a chatroom info' do
      res_hash = @service.chatroom_info('demo')
      expect(res_hash[:code]).to eq(200)
      expect(res_hash[:chatRooms].kind_of?(Array)).to eq(true)
      expect(res_hash[:chatRooms][0][:chrmId]).to eq('demo')
    end

    it 'should query a chatroom users' do
      res_hash = @service.chatroom_users('demo')
      expect(res_hash[:users].kind_of?(Array)).to eq(true)
      expect(res_hash[:code]).to eq(200)
    end

    it 'should destroy a chatroom' do
      res_hash = @service.destroy_chatroom('demo')
      expect(res_hash[:code]).to eq(200)
    end
  end
end
