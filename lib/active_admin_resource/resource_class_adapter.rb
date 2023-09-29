module ActiveAdminResource
  class ResourceClassAdapter
    extend Forwardable

    def_delegators :@resource_class, :name, :format, :primary_key
    def_delegators :chain_helper, :reorder, :page, :ransack, :result, :per

    def initialize(_resource_class)
      @resource_class = _resource_class
    end

    def klass
      self
    end

    def inheritance_column
      nil
    end

    def _ransackers
      {}
    end

    def display_name
      human_model = I18n.t("activerecord.models.#{model_name.i18n_key}.one", default: "")
      return "#{human_model} ##{id}" if human_model.present?

      "#{model_name.name} ##{id}"
    end

    def quoted_table_name
      'resource_not_table'
    end

    def column_names
      content_columns.map &:name
    end

    def content_columns
      @content_columns ||= @resource_class.known_attributes.map { |n| ResourceColumn.new(n) }
    end

    def columns
      content_columns
    end

    def columns_hash
      @columns_hash ||= begin
        test = Hash.new { |h,k| puts "O!! #{k}"; nil }
        content_columns.each { |c| test[c.name] = c }
        test
      end
    end

    def find(_id)
      if @resource_class.respond_to? :process_active_admin_resource_query
        return @resource_class.process_active_admin_resource_query(_id)
      end

      @resource_class.find(_id)
    end

    def query_collection(*_params)
      unless @resource_class.respond_to? :process_active_admin_collection_query
        return ActiveAdminResource::QueryResult.new([], 0)
      end

      @resource_class.process_active_admin_collection_query(*_params)
    end

    def human_attribute_name(attr, _options = {})
      I18n.t("activerecord.attributes.#{name.downcase}.#{attr}", default: attr.to_s.titleize)
    end

    private

    def chain_helper
      @chain_helper ||= ResourceChainHelper.new(self)
    end
  end
end
