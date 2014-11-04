require 'dcell'
require 'cylons/remote_schema'

module Cylons
  class RemoteRegistry
    @remotes ||= []
    @loaded_remotes ||= []
    @remote_schemas ||= {}

    class << self
      attr_accessor :remotes, :loaded_remotes
    end

    def self.clear_registry
      ::DCell.registry.instance_variable_get("@global_registry").clear
    end

    def self.register(klass)
      ::Cylons::Connection.connect unless ::Cylons::Connection.connected?
      @remotes << klass
    end

    def self.register_schemas
      @remotes.each do |remote|
        ::Cylons.logger.info remote
        register_remote_schema(remote)
      end
    end

    def self.remote_schemas
      ::DCell::Global.keys
    end

    def self.register_remote_schema(klass)
      ::DCell::Global["#{klass.name.downcase}_schema".to_sym] = ::Cylons::RemoteSchema.new(klass)
    end

    def self.remote_schema?(name)
      ::DCell::Global.keys.include? "#{name}_schema".to_sym
    end

    def self.get_remote_schema(name)
      ::DCell::Global["#{name}_schema".to_sym]
    end
  end
end
