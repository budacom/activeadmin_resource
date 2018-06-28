require 'active_resource'

module ActiveAdminResource
  module Associations
    def has_many(plural_model_name, options = {})
      klass = Object.const_get plural_model_name.to_s.singularize.classify
      # Getter
      define_method plural_model_name do
        var = instance_variable_get("@#{plural_model_name}")
        if !var.nil?
          var
        else
          collection = if options[:as] # polymorphic
                         foreign_key = "#{options[:as]}_id"
                         foreign_type = "#{options[:as]}_type"
                         klass.where(foreign_type => model_name.name, foreign_key => id)
                       else
                         foreign_key = "#{model_name.name.downcase}_id"
                         klass.where(foreign_key => id)
                       end
          instance_variable_set("@#{plural_model_name}", collection)
        end
      end
      # Setter
      define_method "#{plural_model_name}=" do |value|
        instance_variable_set("@#{plural_model_name}", value)
      end
    end

    def has_one(model_name)
      klass = Object.const_get model_name.to_s.classify
      # Getter
      define_method model_name do
        var = instance_variable_get("@#{model_name}")
        if !var.nil?
          var
        else
          foreign_key = "#{model_name.name.downcase}_id"
          instance_variable_set("@#{model_name}", klass.where(foreign_key => id).first)
        end
      end
      # Setter
      define_method "#{model_name}=" do |value|
        instance_variable_set("@#{model_name}", value)
      end
    end

    Enumerable.send(:define_method, 'and_preload') do |model_to_load|
      model_to_load = model_to_load.to_s.singularize
      klass_to_load = Object.const_get model_to_load.classify
      foreign_ids = map { |collection_item| collection_item.send("#{model_to_load}_id") }.uniq
      preloaded_items = if klass_to_load < ApplicationResource
                          # Class to load must support where(id: [])
                          klass_to_load.where(id: foreign_ids, per: foreign_ids.count)
                        elsif klass_to_load < ApplicationRecord
                          klass_to_load.where(id: foreign_ids)
                        else
                          raise "#{klass_to_load} is not from a supported preload type"
                        end
      each do |collection_item|
        corresponding_preloaded = preloaded_items.find do |pit|
          pit.id == collection_item.send("#{model_to_load}_id")
        end
        collection_item.send("#{model_to_load}=", corresponding_preloaded)
      end
      self
    end
  end
end
