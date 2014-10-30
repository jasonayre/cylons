module Cylons
  module RemotePagination
    extend ::ActiveSupport::Concern

    META_METHODS = [
      :total_pages,
      :current_page
    ].freeze

    SEARCH_OPTION_KEYS = [:opts, :options].freeze
    MAX_PER_PAGE = 1000

    module ClassMethods
      def search(params = {})
        search_options = params.extract!(*SEARCH_OPTION_KEYS)

        search_options.delete_if {|k,v| v.nil? }

        query_scope = params.inject(all) do |query, hash_pair|
          query.__send__("by_#{hash_pair[0]}", hash_pair[1]).all
        end.all

        if search_options.present?
          paginated_results = query_scope.paginate(:page => search_options[:options][:page], :per_page => search_options[:options][:per_page])

          # with_pagination_meta(paginated_result)

        else
          paginated_results = query_scope.paginate(:page => 1, :per_page => MAX_PER_PAGE)

          # binding.pry

          paginated_results

          # with_pagination_meta(paginated_results)
        end
      end

      def with_pagination_meta(result)
        META_METHODS.each do |method|
          result.instance_variable_set("@#{method.to_s}", result.__send__(method))
        end

        result
        # result.inject(META_METHODS) do |result_array, method|
        #   result_array.instance_variable_set("@#{method.to_s}", result_array.__send__(method))
        #   result_array
        # end
        #
        # result
      end
    end



  end
end
