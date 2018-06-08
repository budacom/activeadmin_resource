require 'active_resource'

module ActiveAdminResource
  module GemAdaptors
    module EnumerizeAdaptor
      # Enumerize support
      # Model anyway must declare "extend Enumerize", just like an ActiveRecord model would
      def enumerize(name, options = {})
        # Getter
        define_method name do
          enumerize_attr = self.class.send(name)
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

    module RailsMoneyAdaptor
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
          amount = new_amount.amount
          currency = new_amount.currency
          attributes[:amount] = [amount, currency].map(&:to_s)
        end
      end
    end
  end
end