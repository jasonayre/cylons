module Cylons
  class RemoteSchema
    attr_accessor :remote_associations, :remote_attributes, :remote_search_scopes, :remote_klass

    def initialize(klass)
      @remote_attributes ||= klass.attribute_names
      @remote_associations ||= klass.remote_associations
      @remote_search_scopes ||= []
      @remote_klass ||= klass.name.downcase.to_sym
    end
  end
end
