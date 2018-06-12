require 'active_admin_resource/railties/resource_api_mock/resource_api_mock'
require 'active_admin_resource/railties/resource_api_mock/mock_store'
class ActiveAdminResource::Base
  include ActiveAdminResource::ResourceApiMock
end

RSpec.configure do |config|
  config.before(:example) do |_example|
    ActiveAdminResource::MockStore.drop
  end
end
