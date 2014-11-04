require 'cylons/interface'
require 'cylons/remote_registry'

module Cylons
  class ServiceManager
    def self.start
      ::Cylons.logger.info "STARTING CYLON SERVICES"
      start_services
    end

    #todo: split supervision and building
    def self.start_service(model_klass)
      unless service_defined?(model_klass)
        service_klass = build_service(model_klass)

        service_klass.supervise_as service_klass.name.to_sym
      end
    end

    def self.build_service(model_klass)
      proxy_service_class_name = "#{model_klass.name}Service"
      ::Object.const_set(proxy_service_class_name, ::Class.new(::Cylons::Service))
      service_klass = proxy_service_class_name.constantize
      service_klass.model = model_klass

      ::Cylons.logger.info "REGISTERING_SERVICE_FOR #{model_klass}"

      service_klass
    end

    def self.service_defined?(model_klass)
      proxy_service_class_name = "#{model_klass.name}Service"

      const_defined?(:"#{proxy_service_class_name}")
    end

    def self.start_services
      ::Cylons::RemoteRegistry.remotes.each do |remote|
        start_service(remote)
      end if remotes?
    end

    def self.remotes?
      ::Cylons::RemoteRegistry.remotes.any?
    end

    def self.stop
      ::Cylons::RemoteRegistry.remotes.each do |remote|
        ::Cylons.logger.info{ "Shutting Down #{remote.name}"}
        remote.stop
      end
    end
  end
end
