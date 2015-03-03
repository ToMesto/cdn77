# cdn77

Wrapper for CDN77 API that allows you to do a wide range of commands and tasks from an external script or server.

## Getting started

This gem works with Rails 3.2 onwards. You can add it to your Gemfile with:

```ruby
gem 'cdn77'
```

And then create configuration file in `config/initializers`:

```ruby
Cdn77.configure do |config|
  config.login = 'someone'
  config.password = 'secret'
end
```

Have fun!