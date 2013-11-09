require 'rubygems'
require 'bundler'
require 'cylons'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

Bundler.require(:default, :development, :test)

Dir['./spec/support/*.rb'].map { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    ::InventoryTestNode.start
    ::InventoryTestNode.wait_until_ready
  end

  config.after(:suite) do
    ::InventoryTestNode.stop
  end
end