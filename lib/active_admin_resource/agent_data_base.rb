module ActiveAdminResource
  class AgentDataBase < Base
    self.include_root_in_json = true

    def self.element_path(_id, prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)

      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{format_extension}#{query_string(query_options)}"
    end

    def to_json(options = {})
      permitted_attributes = attributes.slice(*schema.keys)
      rooted_attributes = {}
      rooted_attributes[self.class.element_name] = permitted_attributes
      encoded_attributes = include_root_in_json ? rooted_attributes : permitted_attributes
      ActiveSupport::JSON.encode(encoded_attributes, options)
    end
  end
end
