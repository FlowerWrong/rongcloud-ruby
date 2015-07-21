# README

[融云](http://www.rongcloud.cn/) ruby sdk.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rongcloud', github: 'FlowerWrong/rongcloud-ruby'
```

And then execute:

    $ bundle

## Usage

```ruby
# 基本配置
rails_app/config/initializers/rongcloud.rb
Rongcloud.configure do |config|
  config.app_key = ''
  config.app_secret = ''
  config.host = ''
end
$service = Rongcloud::Service.new

# 获取用户token
$service.get_token('yang', 'yangfusheng', 'https://ruby-china-files.b0.upaiyun.com/user/big_avatar/9442.jpg')

# 创建群组
$service.create_group(user_id, group_id, name = nil)
# 加入群组
$service.add_group(user_id, group_id, name = nil)
# 退出群组
$service.out_group(user_id, group_id)
# 解散群组
$service.dismiss_group(user_id, group_id)
# 刷新群组信息
$service.refresh_group(group_id, name)
```

More usage to see [gem rspec](https://github.com/FlowerWrong/rongcloud-ruby/blob/master/spec/rongcloud/service_spec.rb#L162)

## Rspec

```ruby
cp config.yml.example config.yml
# edit it
rake spec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FlowerWrong/rongcloud. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
