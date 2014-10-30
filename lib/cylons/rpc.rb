require 'ransack'
module Cylons
  module RPC
    extend ::ActiveSupport::Concern
    include ::ActiveModel::Dirty
    include ::Cylons::Attributes

    def all
      ::ActiveRecord::Base.connection_pool.with_connection do
        execute(:all).to_a
      end
    end

    def create(params)
      execute(:create, params)
    end

    def destroy(id)
      execute(:destroy, id)
    end

    def execute(rpc_method, *args)
      puts Thread.current.object_id

      ::ActiveRecord::Base.connection_pool.with_connection do
        puts ::ActiveRecord::Base.connection_pool.instance_variable_get("@connections").size
        begin
          if args.any?
            @last_response = self.class.model.send(rpc_method.to_sym, *args)
          else
            @last_response = self.class.model.send(rpc_method.to_sym)
          end

          @last_response
        rescue => e
          puts e.inspect
          @last_response = {:error => e.message}
        end
      end
    end

    def execute_with_args(rpc_method, *args)
      ::ActiveRecord::Base.connection_pool.with_connection do
        begin
          @last_response = self.class.model.send(rpc_method.to_sym, *args)
        rescue => e
          puts e.inspect
          puts e.message
          puts @last_response.inspect
          @last_response = {:error => e.message}
        end
      end
    end

    def find(id)
      ::ActiveRecord::Base.connection_pool.with_connection do
        execute(:find, id)
      end
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

    def search(params)
      response = execute(:search, params)
      # ::ActiveRecord::Base.connection_pool.with_connection do
      #
      #   response
      # end
    end

    def scope_by(params)
      execute(:scope_by, params)
    end

    def save(id = nil, attributes)
      if(id)
        execute(:update, id, attributes)
      else
        execute(:create, attributes)
      end
    end

    def update(attributes)
      execute(:update, attributes.keys, attributes.values)
    end
  end
end
