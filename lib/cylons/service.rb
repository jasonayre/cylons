require 'celluloid'
require 'cylons/rpc'
module Cylons
  class Service
    include ::Celluloid
    include ::Cylons::RPC
    include ::ActiveModel::Dirty
    include ::Cylons::Attributes
    
    class << self
      attr_accessor :model
    end
      
    def all
      execute(:all)
    end
      
    def create(params)
      execute(:create, params)
    end
      
    def destroy(id)
      execute(:destroy, id)
    end
      
    def execute(rpc_method, request_params = {})
      @last_response = self.class.model.send(rpc_method.to_sym, request_params)
      @last_response
    rescue => e
      @last_response = {:error => e.message}
    end
      
    def execute_with_args(rpc_method, *args)
      @last_response = self.class.model.send(rpc_method.to_sym, *args)
    rescue => e
      @last_response = {:error => e.message}
    end
      
    def find(id)
      execute(:find, id)
    end
      
    def first
      execute(:first)
    end
      
    def first_or_create(params)
      execute(:first_or_create, params)
    end

    def last
      execute(:last)
    end
      
    #todo: Refactor this, hacky
    def search(params)
      response = execute(:search, params)
        
      if response.respond_to?(:result)
        return response.result.to_a
      else
        return response
      end
    end
      
    def scope_by(params)
      execute(:scope_by, params)
    end
      
    def save(id = nil, attributes)
      if(id)
        execute_with_args(:update, id, attributes)
      else
        execute(:create, attributes)
      end
    end
      
    def update(attributes)
      execute_with_args(:update, attributes.keys, attributes.values)
    end
    
  end
end