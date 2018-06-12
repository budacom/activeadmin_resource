require 'active_resource'
require 'active_admin_resource/associations'
require 'active_admin_resource/gem_adaptors'

module ActiveAdminResource
  class Base < ActiveResource::Base
    extend ActiveAdminResource::Associations
    extend Enumerize if defined? Enumerize
    extend ActiveAdminResource::GemAdaptors::EnumerizeAdaptor
    extend ActiveAdminResource::GemAdaptors::MoneyAdaptor

    class JsonFormatter
      include ActiveResource::Formats::JsonFormat

      attr_reader :collection_name
      attr_reader :pagination_info

      def initialize(collection_name)
        @collection_name = collection_name.to_s
      end

      def decode(json)
        pre_process(ActiveSupport::JSON.decode(json))
      end

      private

      def pre_process(data)
        @pagination_info = data['meta']
        data.delete('meta')
        if data.is_a?(Hash) && data.keys.size == 1 && data.values.first.is_a?(Enumerable)
          data.values.first
        elsif data.is_a?(Array) && data.size == 1
          data.first
        else
          data
        end
      end
    end

    self.format = JsonFormatter.new(collection_name)

    cattr_accessor :static_headers
    self.static_headers = headers

    def self.inherited(model)
      model.site = ENV['RESOURCES_API_URL'] if ENV.has_key?('RESOURCES_API_URL')
      super
    end

    def self.agent_id
      ENV['RESOURCES_API_AGENT_ID']
    end

    def self.secret
      ENV['RESOURCES_API_AGENT_SECRET']
    end

    def self.scope(name, body)
      singleton_class.send(:define_method, name, &body)
      # TODO: fix that a 2nd scope defined with same name in another model will override the 1st one,
      # as all model's collections inherit from ActiveResource::Collection
      ActiveResource::Collection.send(:define_method, name, &body)
    end

    def self.human_attribute_name(attr, _options = {})
      I18n.t("activeresource.attributes.#{name.downcase}.#{attr}",
        default: I18n.t("activerecord.attributes.#{name.downcase}.#{attr}",
          default: attr.to_s.titleize))
    end

    def self.headers
      new_headers = static_headers.clone
      new_headers["Content-Type"] = "application/json"
      new_headers["Accept"] = "application/json"
      new_headers["X-Agent-Id"] = agent_id if !agent_id.nil?
      new_headers
    end

    def self.column_names
      content_columns
    end

    def self.content_columns
      if @content_columns.nil?
        @content_columns = Array.new
        known_attributes.each do |name|
          @content_columns << ResourceColumn.new(name)
        end
      end
      @content_columns
    end

    def self.columns
      content_columns
    end

    class ResourceColumn
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def type
        :string
      end
    end

    def self.inheritance_column
      ''
    end

    def self.base_class
      self
    end

    def self.find_by(arg, *_args)
      find(arg[primary_key])
    end

    class << self
      def connection(refresh = false)
        connection = super(refresh)
        _connection.set_secret(secret) if !secret.nil?
        connection
      end
    end
  end
end
