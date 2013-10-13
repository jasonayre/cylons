require 'cylons/remote_registry'
require 'cylons/active_record_extensions'

#todo: fix
#think RemoteRegistry needs to be split into a local registry, which the remote registry
#is pushed information to, or pulls information from, because the damn dcell wont stop
#trying to connect or throwing not configured errors when rake tasks and what not, 
#need complete separation of local/remote
#update, think I mostly fixed issue but leaving note here becaue better separation
#still needs to be done.
module Cylons
  module Remote
    
    def self.included(klass)
      klass.class_eval do
        @remote_associations ||= []
        
        class << self
          attr_accessor :remote_associations
        end
        
        extend ::Cylons::ActiveRecordExtensions::ClassMethods
        extend ::Cylons::Associations::ClassMethods
        
        ::Cylons::RemoteRegistry.register(klass)
      end
    end
  end
end