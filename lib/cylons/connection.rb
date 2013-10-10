require 'cylons'

module Cylons
  class Connection
    class << self
      @connected ||= false
      attr_accessor :connected
      
      alias_method :connected?, :connected
    end
    
    def self.validate_configuration
      raise ::Cylons::RemoteNamespaceNotSet unless ::Cylons.configuration.remote_namespace.present?
    end
    
    #todo: FixMe
    #super hacky.. pass in SKIP_CYLONS=true when running rake tasks for now, ew
    def self.connect?
      ENV['SKIP_CYLONS'].present?
    end
    
    def self.connect
      return if connect?
      validate_configuration
      ::Cylons.logger.info "STARTING DCELL FOR #{::Cylons.configuration.remote_namespace} NOW"
      
      ::Cylons.logger.info "Cylons attempting to connect to registry at #{node_address}"

      ::DCell.start :id => ::Cylons.configuration.remote_namespace,
                    :addr => node_address,
                    :registry => registry_hash
                    
      @connected = true
    end
    
    def self.node_address
      "tcp://#{::Cylons.configuration.address}:#{::Cylons.configuration.port}"
    end
    
    def self.registry_hash
      ::Cylons.configuration.registry
    end
  end
end