require 'cylons/interface'
require 'cylons/remote_registry'

module Cylons
  class ServiceManager
    def self.start
      ::Cylons.logger.info "LOADING REMOTES"
      puts "LOADING REMOTES"
      ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons::RemoteDiscovery.loaded?
      puts "STARTING LOCAL REMOTE SERVICES"
      ::Cylons.logger.info "STARTING LOCAL REMOTE SERVICES"
      start_services
    end
    
    def self.start_service(remote_class)
      service_klass = build_service(remote_class)
      service_klass.supervise_as service_klass.name.to_sym
    end
    
    def self.build_service(remote_class)
      proxy_service_class_name = "#{remote_class.name}Service"
      Object.const_set(proxy_service_class_name, Class.new(::Cylons::Service))
      service_klass = proxy_service_class_name.constantize
      
      service_klass.remote_class = remote_class
      puts "REGISTERING_SERVICE_FOR #{remote_class}"
      service_klass
    end
    
    def self.start_services
      ::Cylons::RemoteRegistry.remotes.each do |remote|
        start_service(remote)
      end if remotes?
    end
    
    def self.service_klass_name
      "#{klass.name}Service"
    end
    
    def self.remotes?
      ::Cylons::RemoteRegistry.remotes.any?
    end
    
    def self.stop
      ::Cylons::RemoteRegistry.remotes.each do |remote|
        remote.stop
      end
    end
  end
end