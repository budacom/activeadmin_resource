module ActiveAdminResource
  class Resource < ActiveAdmin::Resource
    def resource_class
      @resource_class ||= ResourceClassAdapter.new(resource_class_name.constantize)
    end

    def resource_quoted_column_name(_column)
      _column
    end
  end
end