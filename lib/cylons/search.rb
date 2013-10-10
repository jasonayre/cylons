module Cylons
  module Search
    def self.included(klass)
      klass.class_eval do
        include Cylons::Search::InstanceMethods
      end
    end
    
    module InstanceMethods

    end
  end
end