require 'cylons/remote_registry'
require 'cylons/active_record_extensions'

module Cylons
  module Remote
    
    def self.included(klass)
      klass.class_eval do
        @remote_associations ||= []
        @registered_remote_attributes ||= []
        
        class << self
          attr_accessor :remote_associations
          attr_accessor :registered_remote_attributes
        end
        
        extend ::Cylons::ActiveRecordExtensions::ClassMethods
        extend ::Cylons::Associations::ClassMethods
        
        ::Cylons::RemoteRegistry.register(klass)
      end
    end
  end
end