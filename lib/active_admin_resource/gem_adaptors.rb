require 'active_resource'
require 'formtastic'
require 'action_view'
require 'enumerize'

module ActiveAdminResource
  module GemAdaptors
    module EnumerizeAdaptor
      # Enumerize support
      def enumerize(name, options = {})
        # Getter
        define_method name do
          enumerize_attr = self.class.send(name)
          name ||= options[:default]
          Enumerize::Value.new(enumerize_attr, attributes[name.to_sym])
        end
        # Setter
        define_method "#{name}=" do |value|
          enumerize_attr = self.class.send(name)
          unless value.to_s.in? enumerize_attr.values
            raise ArgumentError.new "Invalid value '#{value}' for #{name} enumerized attribute"
          end
          attributes[name.to_sym] = value
        end
        super
      end
    end

    module MoneyAdaptor
      def monetize(*fields)
        options = fields.extract_options!
        fields.each { |field| monetize_field(field, options) }
      end

      def monetize_field(field, _options = {})
        # Getter
        define_method field do
          amount, currency = attributes[field.to_sym]
          Money.from_amount(amount.to_f, currency) if amount
        end
        # Setter
        define_method "#{field}=" do |new_amount|
          field = field.to_sym
          if new_amount.is_a?(Money)
            amount = new_amount.amount
            currency = new_amount.currency
          elsif new_amount.is_a?(Numeric)
            amount = new_amount
            currency = attributes[field].try(:last) || MoneyRails.default_currency.try(:iso_code) || 'USD'
          end
          attributes[field] = [amount, currency].map(&:to_s)
        end
      end
    end
  end
end
