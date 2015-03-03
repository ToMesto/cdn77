require 'bundler/setup'

Bundler.setup

require 'webmock/rspec'
require 'cdn77'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end