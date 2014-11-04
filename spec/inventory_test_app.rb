# The DCell specs start a completely separate Ruby VM running this code
# for complete integration testing using 0MQ over TCP

require 'rubygems'
require 'bundler'
require 'active_record'
Bundler.setup

require 'cylons'

ENV["RPC"] = "1"

::Cylons.configure do |config|
  #if you are running multiple machines, connect to the ZK registry machine via:
  # config.registry_address = "X.X.X.X"
  config.remote_namespace = "InventoryTest"
  # config.registry_adapter = :zk
end

class Product < ActiveRecord::Base
  include ::Cylons::Remote
end

::Cylons::ServiceManager.start
