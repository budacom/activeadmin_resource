module ActiveAdminResource
  class Railtie < Rails::Railtie
    initializer "active_admin_resource.configure_admin_namespace" do
      ::ActiveAdmin::Namespace.prepend(ActiveAdmin::NamespacePatch)
    end
  end
end
