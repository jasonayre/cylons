require 'dcell'

module Cylons
  class RemoteDiscovery
    class << self
      @loaded = false
      attr_accessor :loaded, :loaded_remote_class_names
      alias_method :loaded?, :loaded
    end

    def self.service_mappings
      service_mapping_hash = {}

      ::DCell::Node.all.each do |node|
        namespace = node.id
        filtered_nodes = (node.actors - [:node_manager, :dcell_server, :info])

        remote_class_names = filtered_nodes.select{|name| name.to_s.include?("Service") }.each do |remote_class_name|
          service_mapping_hash[remote_class_name] = node.id
        end
      end

      service_mapping_hash
    end

    def self.namespace_for_agent(agent_name)
      service_mappings["#{agent_name}Service".to_sym]
    end

    def self.remote_class_names
      discovered_remote_class_names = []

      ::DCell::Node.all.each do |node|
        if node.id != ::Cylons.configuration.remote_namespace
          namespace = node.id
          remote_class_names = node.actors - [:node_manager, :dcell_server, :info]
          remote_class_names.select{|name| name.to_s.include?("Service") }.each do |remote_class_name|
            discovered_remote_class_names << remote_class_name
          end if remote_class_names.any?
        end
      end

      discovered_remote_class_names
    end

    def self.remote_proxy_class_name(namespace, remote_class_name)
      "#{namespace}::#{remote_class_name.to_s}".gsub('Service', '')
    end
  end
end
