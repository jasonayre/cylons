require 'dcell'
require 'cylons/remote_proxy'
module Cylons
  class RemoteDiscovery
    class << self
      @loaded = false
      attr_accessor :loaded, :loaded_remote_class_names
      alias_method :loaded?, :loaded
    end
    
    def self.load_remotes
      ::DCell::Node.all.each do |node|
        if node.id != ::Cylons.configuration.remote_namespace
          namespace = node.id
          remote_class_names = node.actors - [:node_manager, :dcell_server, :info]
          puts "HERE ARE THE REMOTE CLASS NAMES"
          puts remote_class_names
          remote_class_names.select{|name| name.to_s.include?("Service") }.each do |remote_class_name|
            build_remote(namespace, remote_class_name)
          end if remote_class_names.any?
        end
      end
      
      @loaded = true
    end
    
    def self.build_remote(namespace, remote_class_name)
      proxy_class_name = remote_class_name.to_s.gsub('Service', '')
      # Object.const_set(namespace.to_s, Module.new) unless !!Object.const_defined?(namespace.to_s)
      # namespace.constantize.const_set(remote_class_name, Class.new)
      Object.const_set(proxy_class_name, Class.new(::Cylons::RemoteProxy))
      
      proxy_class = proxy_class_name.constantize
      proxy_class.load_schema
      proxy_class.remote = ::DCell::Node[namespace][remote_class_name]
    end
    
    def self.remote_proxy_class_name(namespace, remote_class_name)
      "#{namespace}::#{remote_class_name.to_s}".gsub('Service', '')
    end
  end
end