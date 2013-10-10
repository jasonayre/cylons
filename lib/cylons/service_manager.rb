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
    
    def self.start_service(model_klass)
      service_klass = build_service(model_klass)
      service_klass.supervise_as service_klass.name.to_sym
    end
    
    def self.build_service(model_klass)
      proxy_service_class_name = "#{model_klass.name}Service"
      Object.const_set(proxy_service_class_name, Class.new(::Cylons::Service))
      service_klass = proxy_service_class_name.constantize
      
      service_klass.model = model_klass
      puts "REGISTERING_SERVICE_FOR #{model_klass}"
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
  end
end