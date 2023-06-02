module ActiveAdminResource
  class QueryResult
    attr_reader :collection, :total_count, :page

    def initialize(_collection, _total_count, _page)
      @collection = _collection
      @total_count = _total_count
      @page = _page
    end
  end
end