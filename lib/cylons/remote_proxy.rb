require 'cylons/associations'

module Cylons
  
  #this is the local application remote which is dynamically built, from the registry
  class RemoteProxy
    include ::ActiveModel::Dirty
    include ::ActiveModel::AttributeMethods
    include ActiveAttr::Model
    include ActiveAttr::MassAssignment
    include ::Cylons::Attributes
    extend ::Cylons::Associations::ClassMethods
        
    def self.load_schema
      @schema = ::Cylons::RemoteRegistry.get_remote_schema(self.name.downcase)
      
      @schema.remote_attributes.each do |remote_attribute|
        attribute remote_attribute.to_sym
      end
      
      @schema.remote_associations.each do |association_hash|
        __send__("build_remote_#{association_hash[:association_type]}_association", association_hash)
      end
    end
    
    class << self
      attr_accessor :remote, :schema
    end
    
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
        
        if result.is_a?(Hash)
          @errors ||= result
        else
          self.assign_attributes(result.attributes)
        end
      end
      
      result
    end

    def self.all
      remote.all
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
  end
end