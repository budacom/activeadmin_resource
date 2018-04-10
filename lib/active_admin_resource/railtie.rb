require 'active_admin_resource/formtastic_addons_patch'
require 'active_admin_resource/collection_patch'
require 'active_admin_resource/connection_patch'

module ActiveAdminResource 
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do
      ActiveResource::Connection.prepend(ConnectionExtensions)
      ActiveAdmin::Helpers::Collection.prepend(CollectionExtensions)
      ActiveAdmin::Filters::FormtasticAddons.prepend(FormtasticAddonsExtensions)
    end
  end
end
