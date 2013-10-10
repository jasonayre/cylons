require 'cylons'
require 'cylons/registry_adapter'
module Cylons
  class Configuration
    attr_accessor :address,
                  :logger,
                  :port, 
                  :registry_address,
                  :registry_port,
                  :registry_adapter,
                  :registry,
                  :remote_namespace

    #NOTE: I am explicitly setting address to machine address instead of local host due to zookeeper or possibly dcell issue.
    # Basically I have been unable to connect the machine to registry via 
    #:addr => "tcp://localhost:9001" or whatever, have needed to connect using
    #:addr => "tcp://192.168.0.101:9001", not sure if its an id10t error, or a local setting, or zookeeper or dcell
    # lightbulb: maybe because its trying to connect to remote registry, and its telling the remote machine to use localhost?
    # bet thats probably it.. Although I dont think I had same prob w redis. IDONTREMEMBER.
    
    #TODO look into that further.
    def initialize
      self.address = ::Cylons::Interface.primary
      self.port = (9000 + rand(100))
      self.logger = ::Rails.logger if defined?(Rails)
      self
    end
    
    #TODO: uhh refactor this, was having trouble w circular dependency and too tired to trace it down!
    #This introduces order dependency when setting initializer=badmk
    
    def registry_adapter=(adapter)
      raise ::Cylons::InvalidRegistryAdapter unless ::Cylons::RegistryAdapter::VALID_REGISTRY_ADAPTERS.include?(adapter.to_sym)
      @registry_adapter = adapter.to_sym
      @registry = ::Cylons::RegistryAdapter.send(registry_adapter)
    end
  end
end
