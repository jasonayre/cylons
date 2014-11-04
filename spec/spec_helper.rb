require 'rubygems'
require 'bundler'
require 'cylons'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

Bundler.require(:default, :development, :test)

# Dir['./spec/support/*.rb'].map { |f| require f }

if ENV.key?('DEBUG')
  ::Cylons.config.logger = ::Cylons::Logging.initialize_logger($stdout, ::Logger::DEBUG)
elsif ENV.key?('DEBUG_LOG')
  debug_log = ::File.expand_path('../../debug_specs.log', __FILE__)
  ::Cylons.config.logger = ::Cylons::Logging.initialize_logger(debug_log, ::Logger::DEBUG)
else
  ::Cylons.config.logger = ::Cylons::Logging.initialize_logger('/dev/null', ::Logger::FATAL)
end

RSpec.configure do |config|
  config.before(:suite) do
    require 'inventory_test_app'
    require 'support/schema'
  end

  # config.before(:suite) do
  #   ::InventoryTestNode.start
  #   ::InventoryTestNode.wait_until_ready
  # end
  #
  # config.after(:suite) do
  #   puts ::DCell::Node.all.inspect
  #
  #   ::InventoryTestNode.stop
  #
  # end
end
