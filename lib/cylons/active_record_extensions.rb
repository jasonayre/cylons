require 'cylons/remote_discovery'

module Cylons
  module ActiveRecordExtensions
    extend ::ActiveSupport::Concern

    SEARCH_OPTION_KEYS = [:opts, :options].freeze
    MAX_PER_PAGE = 1000

    module ClassMethods
      def reload_remotes!
        ::Cylons::RemoteDiscovery.load_remotes unless ::Cylons.silence?
      end

      def remote_schema
        ::Cylons::RemoteRegistry.get_remote_schema(self.name) unless ::Cylons.silence?
      end

      def remote_belongs_to(*args)
        options = args.extract_options!

        args.each do |arg|
          options[:foreign_key] = "#{arg}_id"
          association_hash = {:name => arg, :association_type => :belongs_to, :options => options}
          self.remote_associations << association_hash
          build_remote_belongs_to_association(association_hash)
        end
      end

      #store remote has many assoc globally, then define it locally.
      def remote_has_many(*args)
        options = args.extract_options!

        args.each do |arg|
          association_hash = {:name => arg, :association_type => :has_many, :options => options}
          self.remote_associations << association_hash
          build_remote_has_many_association(association_hash)
        end
      end

      def search(params = {})
        search_options = params.extract!(*SEARCH_OPTION_KEYS)

        search_options.delete_if {|k,v| v.nil? }

        query_scope = params.inject(all) do |query, hash_pair|
          query.__send__("by_#{hash_pair[0]}", hash_pair[1]).all
        end.all
      end
    end
  end
end
