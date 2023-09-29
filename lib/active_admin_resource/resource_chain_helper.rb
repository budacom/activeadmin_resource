module ActiveAdminResource
  class ResourceChainHelper
    def initialize(_resource_class_adapter)
      @resource_class_adapter = _resource_class_adapter
      @scope_args = [] # we need this variable, activeadmin accesses it directly :painharold:
    end

    def object
      @resource_class_adapter
    end

    def reorder(_query)
      @reorder = _query.split('.').last.parameterize(separator: '_')
      self
    end

    def page(_page)
      @page = _page&.to_i
      self
    end

    def ransack(_ransack)
      @ransack = _ransack
      self
    end

    def result
      self
    end

    def conditions
      self
    end

    def per(_limit_value)
      actual_page = @page || 1

      query_result = @resource_class_adapter.query_collection(
        ransack: @ransack.try(:permit!)&.to_h,
        reorder: @reorder,
        page: actual_page,
        per: _limit_value
      )

      actual_page = query_result.page if query_result.page.present?

      @ary = Kaminari.paginate_array(
        query_result.collection,
        limit: _limit_value,
        offset: (actual_page - 1) * _limit_value,
        total_count: query_result.total_count
      )
    end

    def map(*_args)
      @ary = @ary.map *_args
      self
    end

    def each(*_args)
      @ary.each *_args
      self
    end

    def to_ary
      @ary
    end

    def method_missing(method_name, *args, &block)
      @ransack[method_name]
    end
  end
end
