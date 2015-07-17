require 'net/http'
require 'openssl'

class HttpClient
  # 合成Get请求参数
  def get_request(url, params = nil, header = nil)
    base_get_del_request(Net::HTTP::Get, url, params, header)
  end

  # 合成Post请求参数
  def post_request(url, params = nil, header = nil)
    base_put_post_request(Net::HTTP::Post, url, params, header)
  end

  # 合成Delete请求参数
  def del_request(url, params = nil, header = nil)
    base_get_del_request(Net::HTTP::Delete, url, params, header)
  end

  # 合成Put请求参数
  def put_request(url, params = nil, header = nil)
    base_put_post_request(Net::HTTP::Put, url, params, header)
  end

  # 发起网络请求
  def submit(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 3000
    if uri.scheme == 'https'
      http.use_ssl = true
      verify_mode = OpenSSL::SSL::VERIFY_NONE  # OpenSSL::SSL::VERIFY_PEER
      http.verify_mode = verify_mode
    end
    http.request request
  end

  private

  def base_get_del_request(method_klass, url, params, header)
    uri = URI(url)
    uri.query = URI.encode_www_form(params) unless params.nil?
    req = method_klass.new(uri)
    init_header_and_return(uri, req, header)
  end

  def base_put_post_request(method_klass, url, params, header)
    uri = URI.parse(url)
    req = method_klass.new(uri)
    req.content_type = 'application/json'
    req.body = params.to_json unless params.nil?
    init_header_and_return(uri, req, header)
  end

  def init_header_and_return(uri, req, header)
    req.initialize_http_header(header) if header
    [uri, req]
  end
end
