module Cylons
  module ActiveRecord
    module Attributes
      def read_attribute(name)
        name = name.to_s
      
        if @attributes.has_key?(name) || self.respond_to?(name)
          @attributes[name]
        else
          raise ::ActiveAttr::UnknownAttributeError, "unknown attribute: #{name}"
        end
      end
      alias_method :[], :read_attribute
  
      # Override #write_attribute (along with #[]=) so we can provide support for
      # ActiveModel::Dirty.
      #
      def write_attribute(name, value)
        __send__("#{name}_will_change!") if value != self[name]
      
        name = name.to_s
  
        if @attributes.has_key?(name) || self.respond_to?(name)
          @attributes[name] = value
        else
          raise ::ActiveAttr::UnknownAttributeError, "unknown attribute: #{name}"
        end
      end
      alias_method :[]=, :write_attribute
      alias_method :attribute=, :write_attribute
    end
  end
end