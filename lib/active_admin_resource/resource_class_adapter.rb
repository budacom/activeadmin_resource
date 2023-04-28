module ActiveAdminResource
  class ResourceClassAdapter
    extend Forwardable

    def_delegators :@resource_class, :name, :find, :format, :primary_key
    def_delegators :chain_adaptor, :reorder, :page, :ransack, :result, :per

    def initialize(_resource_class)
      @resource_class = _resource_class
    end

    def klass
      self
    end

    def _ransackers
      {}
    end

    def display_name
      human_model = I18n.t("activerecord.models.#{model_name.i18n_key}.one", default: "")
      return "#{human_model} ##{id}" if human_model.present?

      "#{model_name.name} ##{id}"
    end

    def column_names
      content_columns
    end

    def content_columns
      if @content_columns.nil?
        @content_columns = Array.new
        @resource_class.known_attributes.each do |name|
          @content_columns << ResourceColumn.new(name)
        end
      end

      @content_columns
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

    def human_attribute_name(attr, _options = {})
      I18n.t("activerecord.attributes.#{name.downcase}.#{attr}", default: attr.to_s.titleize)
    end

    private

    def chain_adaptor
      @chain_adaptor ||= ResourceChainAdapter.new(@resource_class)
    end
  end
end