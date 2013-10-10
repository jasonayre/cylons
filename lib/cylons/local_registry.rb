require 'dcell'
require 'cylons/remote_schema'
require 'cylons/remote_registry'

module Cylons
  class LocalRegistry

    @remotes ||= []
    @loaded_remotes ||= []
    
    class << self
      attr_accessor :remotes, :loaded_remotes
    end
    
    def self.register(klass)
      @remotes << klass
    end
  
    def self.register_class?(namespaced_class_name)
      !defined?(namespaced_class_name.constantize)
    end
    
    def self.register_remote_schemas
      @remotes.each do |remote|
        ::Cylons::RemoteRegistry.register_remote_schema(remote)
      end
    end
    
  end 
end