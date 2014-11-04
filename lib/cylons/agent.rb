require 'cylons/associations'

module Cylons

  #this is the local application remote which is dynamically built, from the registry
  class Agent
    include ::ActiveModel::Dirty
    include ::ActiveModel::AttributeMethods
    include ::ActiveAttr::Model
    include ::ActiveAttr::MassAssignment
    include ::Cylons::Attributes
    include ::Cylons::Associations

    class_attribute :unsucessful_remote_connection_attempts
    self.unsucessful_remote_connection_attempts ||= 0

    class << self
      attr_accessor :schema, :built
    end

    @built = false

    def self.inherited(subklass)
      ::Cylons.connect unless ::Cylons.connected?
    end

    def self.build_agent
      load_schema
      @built = true
    end

    def self.service_class_name
      "#{name}Service"
    end

    def self.load_schema
      ::Cylons.logger.debug { "Loading schema for #{name}" }

      @schema = ::Cylons::RemoteRegistry.get_remote_schema(name.downcase)

      @schema.remote_attributes.each do |remote_attribute|
        attribute remote_attribute.to_sym
      end

      @schema.remote_associations.each do |association_hash|
        __send__("build_remote_#{association_hash[:association_type]}_association", association_hash)
      end
    end

    def self.all
      remote.all
    end

    def self.agent_namespace
      @agent_namespace ||= ::Cylons::RemoteDiscovery.namespace_for_agent(self.name)
    end

    def self.count
      remote.count
    end

    def self.first
      remote.first
    end

    def self.find(id)
      remote.find(id)
    end

    def self.last
      remote.last
    end

    def self.create(params)
      remote.create(params)
    end

    def self.search(params)
      remote.search(params)
    end

    def self.scope_by(params)
      remote.scope_by(params)
    end

    def self.first_or_create(params)
      result = remote.scope_by(params).first
      result = remote.create(params) unless result.present?
      result
    end

    def self.first_or_initialize(params)
      result = remote.scope_by(params).first
      result ||= remote.new(params) unless result.present?
      result
    end

    def self.remote
      remote_connection_failed! unless remote?

      build_agent unless built

      ::DCell::Node[agent_namespace][service_class_name.to_sym]
    end

    def self.remote?
      agent_namespace && remote_application? && remote_service?
    end

    def self.remote_application?
      ::DCell::Node.all.any?{ |node|
        node.id == agent_namespace
      }
    end

    def self.remote_service?
      ::DCell::Node[agent_namespace].actors.include?(service_class_name.to_sym)
    end

    def self.remote_connection_failed!
      if self.unsucessful_remote_connection_attempts > ::Cylons.config.remote_connection_failure_threshold
        self.unsucessful_remote_connection_attempts = 0
        raise ::Cylons::CylonsRemoteServiceNotFound, "#{service_class_name} not found"
      else
        sleep(::Cylons.config.remote_connection_failure_timeout)
        self.unsucessful_remote_connection_attempts += 1
        remote_connection_failed! unless remote?
      end
    end

    attr_accessor :errors

    def destroy
      return unless self.attributes["id"]
      result = self.class.remote.destroy(self.attributes["id"])
    end

    #have to manually update attributes if id wasnt set, i believe attr_accessible oddity so maybe can rip out later
    def save
      if self.attributes["id"]
        result = self.class.remote.save(self.attributes["id"], self.attributes.with_indifferent_access.slice(*self.changed))
        self.changed_attributes.clear
      else
        result = self.class.remote.save(nil, self.attributes.with_indifferent_access.slice(*self.changed))

        if result.errors.messages.present?
          self.assign_attributes({:errors => result.errors})
        else
          self.assign_attributes(result.attributes)
        end
      end

      result
    end
  end
end
