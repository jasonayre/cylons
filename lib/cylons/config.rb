require 'active_support/ordered_options'
require 'cylons'
require 'cylons/registry_adapter'

module Cylons
  class Config < ::ActiveSupport::InheritableOptions
    def initialize(*args)
      super(*args)

      self[:address] ||= ::Cylons::Interface.primary
      self[:port] ||= (9000 + rand(100))
      self[:logger] ||= ::Cylons::Logging.logger
      self[:model_paths] ||= nil
      self[:registry] ||= nil
      self[:registry_adapter] ||= :zk
      self[:registry_port] ||= nil
      self[:remote_namespace] ||= nil
      self[:remote_connection_failure_timeout] ||= 10
      self[:remote_connection_failure_threshold] ||= 2
    end

    def registry
      @registry ||= ::Cylons::RegistryAdapter.send(self[:registry_adapter])
    end
  end
end
