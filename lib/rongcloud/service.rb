require 'json'
require 'active_support/core_ext/hash/keys'
require 'rest-client'
require 'logging'

module Rongcloud
  class Service
    def initialize
      @app_key = Rongcloud.config.app_key
      @app_secret = Rongcloud.config.app_secret
      @host = Rongcloud.config.host
      @sign_header = Rongcloud::Sign.sign_headers(@app_key, @app_secret)

      $logger = Logging.logger['rongcloud']
      $logger.level = Rongcloud.config.log_level
      $logger.add_appenders Logging.appenders.stdout, Logging.appenders.file(Rongcloud.config.log_file)
    end

    ## 用户服务
    # 获取 Token
    def get_token(user_id, name = nil, portrait_uri = nil)
      url = "#{@host}/user/getToken.json"
      params = {
        userId: user_id,
        name: name,
        portraitUri: portrait_uri
      }
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "get_token response is #{res}"
      be_symbolized res
    end

    # 刷新用户信息
    def refresh_user(user_id, name = nil, portrait_uri = nil)
      url = "#{@host}/user/refresh.json"
      params = { userId: user_id }
      params.merge!({ name: name }) unless name.nil?
      params.merge!({ portraitUri: portrait_uri }) unless portrait_uri.nil?
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "refresh_user response is #{res}"
      be_symbolized(res)
    end

    # 检查用户在线状态
    def online_status(user_id)
      url = "#{@host}/user/checkOnline.json"
      params = { userId: user_id }
      res = RestClient.post url, params, @sign_header
      be_symbolized(res)
    end

    ## 用户封禁服务
    # 封禁用户
    def block_user(user_id, minute = 60)
      url = "#{@host}/user/block.json"
      params = { userId: user_id, minute: minute }
      res = RestClient.post url, params, @sign_header
      be_symbolized(res)
    end

    # 获取被封禁用户
    def block_users
      url = "#{@host}/user/block/query.json"
      params = {}
      res = RestClient.post url, params, @sign_header
      be_symbolized(res)
    end

    # 解除用户封禁
    def unblock_user(user_id)
      url = "#{@host}/user/unblock.json"
      params = { userId: user_id }
      res = RestClient.post url, params, @sign_header
      be_symbolized(res)
    end

    ## 用户黑名单服务
    # 添加用户到黑名单
    def add_black(user_id, black_user_id)
      url = "#{@host}/user/blacklist/add.json"
      params = {
        userId: user_id,
        blackUserId: black_user_id
      }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 获取某用户的黑名单列表
    def blacklist(user_id)
      url = "#{@host}/user/blacklist/query.json"
      params = { userId: user_id }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 从黑名单中移除用户
    def remove_black(user_id, black_user_id)
      url = "#{@host}/user/blacklist/remove.json"
      params = {
        userId: user_id,
        blackUserId: black_user_id
      }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    ## 消息发送服务
    # 发送单聊消息
    def send_private_msg(from_uid, to_uid, msg_type, content, push_content = nil, push_data = nil, count = nil)
      url = "#{@host}/message/private/publish.json"
      params = {
        fromUserId: from_uid,
        toUserId: to_uid,
        objectName: msg_type,
        content: content.to_json
      }
      params.merge!({ pushContent: push_content }) unless push_content.nil?
      params.merge!({ pushData: push_data }) unless push_data.nil?
      params.merge!({ count: count }) unless count.nil?
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 发送模板消息
    # NO TEST
    def send_template_msg(from_uid, to_uid, msg_type, values, content, push_content, push_data)
      url = "#{@host}/message/private/publish_template.json"
      params = {
        fromUserId: from_uid,
        toUserId: to_uid,
        objectName: msg_type,
        values: values,
        content: content.to_json,
        pushContent: push_content,
        pushData: push_data
      }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 发送系统消息
    def send_sys_msg(from_uid, to_uid, msg_type, content, push_content = nil, push_data = nil)
      url = "#{@host}/message/system/publish.json"
      params = {
        fromUserId: from_uid,
        toUserId: to_uid,
        objectName: msg_type,
        content: content.to_json
      }
      params.merge!({ pushContent: push_content }) unless push_content.nil?
      params.merge!({ pushData: push_data }) unless push_data.nil?
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 发送群组消息
    def send_group_msg(from_uid, to_uid, msg_type, content, push_content = nil, push_data = nil)
      url = "#{@host}/message/group/publish.json"
      params = {
        fromUserId: from_uid,
        toUserId: to_uid,
        objectName: msg_type,
        content: content.to_json
      }
      params.merge!({ pushContent: push_content }) unless push_content.nil?
      params.merge!({ pushData: push_data }) unless push_data.nil?
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 发送聊天室消息
    def send_chatroom_msg(from_uid, to_uid, msg_type, content)
      url = "#{@host}/message/chatroom/publish.json"
      params = {
        fromUserId: from_uid,
        toUserId: to_uid,
        objectName: msg_type,
        content: content.to_json
      }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 发送广播消息
    def send_broadcast_msg(from_uid, msg_type, content, push_content = nil, push_data = nil)
      url = "#{@host}/message/broadcast.json"
      params = {
        fromUserId: from_uid,
        objectName: msg_type,
        content: content.to_json
      }
      params.merge!({ pushContent: push_content }) unless push_content.nil?
      params.merge!({ pushData: push_data }) unless push_data.nil?
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "send_broadcast_msg response is #{res}"
      be_symbolized res
    end

    ## 消息路由服务
    # 同步消息
    # FIXME
    def sync_msg(from_uid, to_uid, msg_type, content, timestamp, channel_type, msg_timestamp)
    end

    ## 消息历史记录服务
    # 消息历史记录下载地址获取
    # date = '2014010101'
    def msg_history_download(date)
      url = "#{@host}/message/history.json"
      params = { date: date }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 消息历史记录删除
    # date = '2014010101'
    def msg_history_del(date)
      url = "#{@host}/message/history/delete.json"
      params = { date: date }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    ## 群组服务
    # 同步用户所属群组
    def sync_group(user_id, groups)
      url = "#{@host}/group/sync.json"
      params = { userId: user_id, group: groups.to_json }
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} sync_group response is #{res}"
      be_symbolized res
    end

    # 创建群组
    def create_group(user_id, group_id, name = nil)
      url = "#{@host}/group/create.json"
      params = { userId: user_id, groupId: group_id }
      params.merge!({ groupName: name }) unless name.nil?
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} create_group response is #{res}"
      be_symbolized res
    end

    # 加入群组
    def add_group(user_id, group_id, name = nil)
      url = "#{@host}/group/join.json"
      params = { userId: user_id, groupId: group_id }
      params.merge!({ groupName: name }) unless name.nil?
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        $logger.warn "#{Time.now} add_group exception is #{e}"
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} add_group response is #{res}"
      be_symbolized res
    end

    # 退出群组
    def out_group(user_id, group_id)
      url = "#{@host}/group/quit.json"
      params = { userId: user_id, groupId: group_id }
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} out_group response is #{res}"
      be_symbolized res
    end

    # 解散群组
    def dismiss_group(user_id, group_id)
      url = "#{@host}/group/dismiss.json"
      params = { userId: user_id, groupId: group_id }
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        $logger.warn "#{Time.now} dismiss_group exception is #{e}"
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} dismiss_group response is #{res}"
      be_symbolized res
    end

    # 刷新群组信息
    def refresh_group(group_id, name)
      url = "#{@host}/group/refresh.json"
      params = { groupId: group_id, groupName: name }
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      $logger.warn "#{Time.now} refresh_group response is #{res}"
      be_symbolized res
    end

    ## 聊天室服务
    # 创建聊天室
    # {id: name, id: name}
    def create_chatroom(chatroom = {})
      url = "#{@host}/chatroom/create.json"
      params = { chatroom: chatroom }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 查询聊天室信息
    def chatroom_info(chatroom_id)
      url = "#{@host}/chatroom/query.json"
      params = { chatroomId: chatroom_id }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 查询聊天室内用户
    def chatroom_users(chatroom_id)
      url = "#{@host}/chatroom/user/query.json"
      params = { chatroomId: chatroom_id }
      res = RestClient.post url, params, @sign_header
      be_symbolized res
    end

    # 销毁聊天室
    def destroy_chatroom(chatroom_id)
      url = "#{@host}/chatroom/destroy.json"
      if chatroom_id.kind_of?(Array)
        params = ''
        chatroom_id.each do |cid|
          params += "chatroomId=#{cid}&"
        end
        params = params.chop
      else
        params = { 'chatroomId' => chatroom_id }
      end
      begin
        res = RestClient.post url, params, @sign_header
      rescue => e
        res = e.response.inspect
      end
      be_symbolized res
    end

    private

    def be_symbolized(res)
      begin
        res_hash = JSON.parse res
        res_hash = res_hash.kind_of?(Array) ? res_hash.map(&:deep_symbolize_keys!) : res_hash.deep_symbolize_keys!
        res_hash[:http_code] = res.code
      rescue => e
        res_hash = e.message
        $logger.warn "be_symbolized res is #{res}"
        $logger.warn "be_symbolized exception is #{e}"
      end
      res_hash
    end

    def http_status
      {
        200 => '成功 => 成功',
        400 => '错误请求 => 该请求是无效的，详细的错误信息会说明原因',
        401 => '验证错误 => 验证失败，详细的错误信息会说明原因',
        403 => '被拒绝 => 被拒绝调用，详细的错误信息会说明原因',
        404 => '无法找到 => 资源不存在',
        429 => '过多的请求 => 超出了调用频率限制，详细的错误信息会说明原因',
        500 => '内部服务错误 => 服务器内部出错了，请联系我们尽快解决问题',
        504 => '内部服务响应超时 => 服务器在运行，本次请求响应超时，请稍后重试'
      }
    end

    def rongcloud_status
      {
        1000 => '服务内部错误 => 服务器端内部逻辑错误,请稍后重试 => 500',
        1001 => 'App Secret 错误 => App Key 与 App Secret 不匹配 => 401',
        1002 => '参数错误 => 参数错误，详细的描述信息会说明 => 400',
        1003 => '无 POST 数据 => 没有 POST 任何数据 => 400',
        1004 => '验证签名错误 => 验证签名错误 => 401',
        1005 => '参数长度超限 => 参数长度超限，详细的描述信息会说明 => 400',
        1006 => 'App 被锁定或删除 => App 被锁定或删除 => 401',
        1007 => '被限制调用 => 该方法被限制调用，详细的描述信息会说明 => 401',
        1008 => '调用频率超限 => 调用频率超限，详细的描述信息会说明 => 429',
        1050 => '内部服务超时 => 内部服务响应超时 => 504',
        2007 => '测试用户数量超限 => 测试用户数量超限 => 403'
      }
    end
  end
end
