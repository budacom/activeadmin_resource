module ColumnExtensions
  def sortable?
    if @options.has_key?(:sortable)
      !!@options[:sortable]
    elsif @resource_class
      @resource_class.column_names.map(&:name).include?(sort_column_name)
    else
      @title.present?
    end
  end
end
