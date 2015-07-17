require 'securerandom'
require 'digest/sha1'

module Rongcloud
  module Sign
    # 生成header数据
    def self.sign_headers(app_key, app_secret)
      nonce = SecureRandom.hex(16)
      timestamp = Time.now.to_i.to_s

      str = [app_secret, nonce, timestamp].join('')
      signature = Digest::SHA1.hexdigest(str)
      {
        'App-Key' => app_key,
        'Nonce' => nonce,
        'Timestamp' => timestamp,
        'Signature' => signature
      }
    end
  end
end
