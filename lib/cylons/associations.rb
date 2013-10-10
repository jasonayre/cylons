module Cylons
  module Associations
    module ClassMethods
      #To make service load order a non issue, we need to be trixy hobbitses
      #Here we catch uninitialized constant error and reload remotes if constant hasnt been defined yet
      #i.e. if a Product service loads after category service, when Product calls the Category.search method
      #it will throw constant error, we catch that, reload remotes and try one mo time
      
      def build_remote_belongs_to_association(association_hash)
        define_method(association_hash[:name]) do
          begin
            foreign_key = association_hash[:options].fetch(:foreign_key, association_hash[:name].to_s.underscore.to_sym)
            association_hash[:name].to_s.classify.constantize.scope_by(:id => self[foreign_key]).first
          rescue => e
            if e.message == "uninitialized constant #{association_hash[:name].classify.to_s}"
              ::Cylons::RemoteDiscovery.load_remotes
              association_hash[:name].to_s.classify.constantize.scope_by(:id => self["#{association_hash[:name].to_s}_id".to_sym]).first
            end
          end
        end
      end

      def build_remote_has_many_association(association_hash)
        define_method(association_hash[:name]) do
          begin
            klass_name = association_hash[:options].fetch(:class_name, association_hash[:name].to_s.singularize.classify)
            foreign_key = association_hash[:options].fetch(:foreign_key, "#{self.class.name.singularize}_id".downcase.to_sym)
            klass = klass_name.constantize
            klass.scope_by(foreign_key => self[:id])
          rescue => e
            if e.message == "uninitialized constant #{klass_name}"
              ::Cylons::RemoteDiscovery.load_remotes
              klass.scope_by(:id => self["#{association_hash[:name].to_s.singularize}_id"].to_sym)
            end
          end
        end
      end
    end
  end
end