# cdn77

[![Gem Version](https://badge.fury.io/rb/cdn77.svg)](http://badge.fury.io/rb/cdn77)

Wrapper for CDN77 API that allows you to do a wide range of commands and tasks from an external script or server.

## Installation

This gem works with Rails 3.2 onwards. To make it available just add following lines into your Gemfile:

```ruby
gem "cdn77"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install cdn77
```
And require in irb:

```ruby
require "cdn77"
```

## Using

To perform any requests use simple wrapper:

```ruby
config = Cdn77::Configuration.new(:login => "someone@example.com", :password => "secret")
cdn = Cdn77.cdn(config)
cdn.get("account", "details") 
# {:status => "ok", :description => "Request was successful.", :account => ...}
```

If you want to setup configuration only once you should take a look on `Cdn77.configure`. For example, it is a good idea to create initializer with following code in Rails:

```ruby
# config/initializers/cdn77.rb

Cdn77.configure do |config|
  config.login = "someone@example.com"
  config.password = "secret"
end
```

Now just call API's method in any part of your application:

```ruby
Cdn77.cdn.get("account", "details")
# {:status => "ok", :description => "Request was successful.", :account => ...}
```

Of course, you can override global configuration if needed. For example:

```ruby
Cdn77.configure do |config|
  config.login = "someone@example.com"
  config.password = "secret"
end
Cdn77.cdn.get("account", "details", :login => "someoneelse@example.com", :password => 'elsesecret')
```

To make requests using HTTP POST call `post` method:

```ruby
Cdn77.cdn.post("account", "edit", :full_name => "Martin Eden")
```

 And have fun!

## Contributing

1. Fork it ( https://github.com/ToMesto/cdn77/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
