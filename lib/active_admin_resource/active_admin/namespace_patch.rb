module ActiveAdminResource
  module ActiveAdmin
    module NamespacePatch
      def find_or_build_resource(resource_class, options)
        if resource_class < ActiveResource::Base
          resources.add ActiveAdminResource::Resource.new(self, resource_class, options)
        else
          resources.add ::ActiveAdmin::Resource.new(self, resource_class, options)
        end
      end
    end
  end
end
