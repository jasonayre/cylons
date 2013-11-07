module Cylons
  class RemoteSchema
    attr_accessor :remote_associations, :remote_attributes, :remote_search_scopes, :remote_klass
    
    #this class is basically blank schema that holds attributes and gets marshalled to global registry
    #hacky stuff for rails 3/4 compatibility for now, may add typecasting and what not later
    #rails4 must specify remote_attributes in model
    def initialize(klass)
      if klass.registered_remote_attributes.any?
        puts "REGISERED REMOTE ATTRS EXIST"
        @remote_attributes = klass.registered_remote_attributes.map{ |attribute_hash| attribute_hash[:name] }
      else
        klass.attribute_names.map{ |attr_name| klass.remote_attribute(attr_name) }
        @remote_attributes = klass.registered_remote_attributes
      end
      
      @remote_associations ||= klass.remote_associations
      @remote_search_scopes ||= []
      @remote_klass ||= klass.name.downcase.to_sym
    end
  end
end