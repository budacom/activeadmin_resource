module ActiveAdminResource
  class ResourceChainAdapter
    def initialize(_resource_class)
      @resource_class = _resource_class
    end

    def object
      ResourceClassAdapter.new(@resource_class)
    end

    def reorder(_arel)
      self
    end

    def page(_page)
      @page = _page
      self
    end

    def ransack(_q)
      @q = _q
      self
    end

    def result
      self
    end

    def conditions
      self
    end

    def per(_limit_value)
      @limit_value = _limit_value

      resources = @resource_class.find(:all, params: { search: @q.try(:permit!).to_h })

      pagination_info = @resource_class.format.pagination_info
      offset = (pagination_info['current_page'] - 1) * _limit_value

      @ary = Kaminari.paginate_array(
        resources,
        limit: _limit_value,
        offset: offset,
        total_count: pagination_info['total_count']
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
      @q[method_name]
    end
  end
end