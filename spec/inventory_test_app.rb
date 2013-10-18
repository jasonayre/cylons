# The DCell specs start a completely separate Ruby VM running this code
# for complete integration testing using 0MQ over TCP

require 'rubygems'
require 'bundler'
Bundler.setup

require 'cylons'

::Cylons.configure do |config|
  #if you are running multiple machines, connect to the ZK registry machine via:
  # config.registry_address = "X.X.X.X"
  config.logger = Logger.new(STDOUT)
  config.remote_namespace = "InventoryTest"
  config.registry_adapter = :redis
end

::Cylons.connect

puts ::Cylons.connected?

class Product < ActiveRecord::Base
  include ::Cylons::Remote
end

::Cylons::ServiceManager.start_services