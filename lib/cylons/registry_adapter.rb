require 'cylons'
require 'cylons/interface'

module Cylons
  class RegistryAdapter
    
    VALID_REGISTRY_ADAPTERS = [:zk, :redis].freeze
    
    #TODO: Add redis adapter support... maybe..
    
    def self.zk_defaults
      {:adapter => 'zk', :port => '2181', :server => ::Cylons::Interface.primary}
    end
    
    def self.zk(options = {})
      zk_registry_hash = zk_defaults.dup
      zk_registry_hash[:server] = ::Cylons.configuration.registry_address if ::Cylons.configuration.registry_address
      zk_registry_hash[:registry_port] = ::Cylons.configuration.registry_port if ::Cylons.configuration.registry_port
      zk_registry_hash
    end
    
    def self.redis_defaults
      {:adapter => 'redis', :port => 6379, :address => "127.0.0.1"}
    end
    
    def self.redis(options = {})
      redis_registry_hash = redis_defaults.dup
      redis_registry_hash
    end
  end
end