# Active Admin Resource

Extension of [ActiveResource](https://github.com/rails/activeresource) to allow integration
with [ActiveAdmin](https://github.com/activeadmin/activeadmin).

## Disclaimer

This gem is work in progress. There is only partial support of ActiveAdmin for now, and the are some specific limitation and requirements that need to be considered when using it. 

Pull Requests with improvements are welcomed :)

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'active_admin_resource', github: "budacom/activeadmin_resource"
```

And then execute:

    $ bundle

## Usage

This gem provides a base class that extends from ActiveResource and patches some missing functions in both ActiveAdmin and ActiveResource. The patches are executed when the gem is loaded.

### ActiveAdminResource::Base

This is the base class that you need to use to create ActiveAdmin enabled ActiveResource models. You need to extend your model with this base class, and define the minimum fields required by ActiveResource as in the following example: 

```ruby
class Market < ActiveAdminResource::Base
  self.site = "http://localhost/api/"

  schema do
    attribute 'id', :string
    attribute 'name', :string
    attribute 'base_currency', :string
    attribute 'quote_currency', :string
  end
end
```

This base class allows also to perform signed requests using the [Authograph gem](https://github.com/budacom/authograph/). To enable this, the class must implement the class method *self.secret* and return the private key in that method. Additionaly, an id of the requester can be provided by implementing the *self.agent_id* method as the following example shows:  

```ruby
class Account < ActiveAdminResource::Base
  self.site = "http://localhost/signed_api/"

  def self.agent_id
    #Return id
  end

  def self.secret
    #Return secret
  end

  schema do
    attribute 'id', :integer
    attribute 'name', :string
  end
end

```
When registering an ActiveAdminResource model with ActiveAdmin some additional considerations must be taken:


* Batch actions are not supported, so they should be disabled.
* Although filters are not currently supported, one filter must be declared so this model works with ActiveAdmin.
* The *find_collection* method of *controller* must be overriden and return a paginated array as a result.
* Pagination is supported by providing pagination info in the server response. The currently supported pagination format expect a *meta* field in the response with a dictionary that has the following fields describing the pagination: *total_pages*, *total_count* and *current_page*.
When a response is requested, the pagination info is stored in *Model.format.pagination_info* and can be used to paginate the info accordingly.


The following example shows an ActiveAdminResource model being registered for ActiveAdmin and using the pagination schema explained before. 

```ruby
  
ActiveAdmin.register Account do
  config.batch_actions = false

  # Filters are not working but one filter has to be declared for the admin to work
  filter :names, as: :string, label: "Names"

  controller do
    def find_collection
      default_per_page = 50
      per_page = params.fetch(:per_page, default_per_page)
      @search = OpenStruct.new(params[:q] || {})
      result = Account.find(:all, params: {
        page: params.fetch(:page, 1),
        per: per_page,
        q: params[:q] || {}
      })
      pagination_info = Account.format.pagination_info
      offset = (pagination_info["current_page"] - 1) * per_page
      Kaminari.paginate_array(result, limit: result.count, offset: offset, total_count: pagination_info["total_count"])
    end
  end
end

```


### Limitations and Poorly tested cases

As explained before, there are several limitations and poorly tested cases in the current version:

* Filters are not supported
* Search is not supported
* Batch actions are not supported
* POST, PUT and DELETE actions are not tested well and may have issues
