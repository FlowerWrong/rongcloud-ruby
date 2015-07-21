require 'json'
require 'active_support/core_ext/hash/keys'
require 'rest-client'
require 'symbolized'

module Rongcloud
  class Service
    def initialize
      @app_key = Rongcloud.config.app_key
      @app_secret = Rongcloud.config.app_secret
      @host = Rongcloud.config.host
      @sign_header = Rongcloud::Sign.sign_headers(@app_key, @app_secret)
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
      res = RestClient.post url, params, @sign_header
      be_symbolized(res)
    end

    private

    def be_symbolized(res)
      res_hash = JSON.parse res
      res_hash = res_hash.to_symbolized_hash
      # res_hash = res_hash.kind_of?(Array) ? res_hash.map(&:deep_symbolize_keys!) : res_hash.deep_symbolize_keys!
      res_hash[:http_code] = res.code
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
