module ColumnExtensions
  def sortable?
    if @options.has_key?(:sortable)
      !!@options[:sortable]
    elsif @resource_class
      @resource_class.column_names.map { |c| c.is_a?(String) ? c : c.name }
                     .include?(sort_column_name)
    else
      @title.present?
    end
  end
end
