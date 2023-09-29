# Active Admin Resource

Extension of [ActiveResource](https://github.com/rails/activeresource) to allow integration
with [ActiveAdmin](https://github.com/activeadmin/activeadmin).

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'active_admin_resource', github: "budacom/activeadmin_resource"
```

And then execute:

    $ bundle

Since API quering changes from one ActiveResource integration to another, for this gem to work the proyect's base resource class must implement the following methods:

### `process_active_admin_collection_query(ransack:, reorder:, page:, per:)`

This method will be called with the following arguments:
- `ransack`: ransack query activeadmin is trying to apply to collection
- `reorder`: ordering query activeadmin is trying to apply to collection
- `page`: page number
- `per`: results per page

The method must respond with an instance of `ActiveAdminResource::QueryResult`, that can be built using `ActiveAdminResource::QueryResult.new(collection, total_count, page)`, where:
- `collection`: an array of resource instances
- `total_count`: the total count of resources after applying filters (`nil` if not available)
- `page`: the current page (`nil` if not available)

### `process_active_admin_resource_query(_id)` (optional)

If this method is defined, it will be called instead if `find`

## Limitations

**WARNING! There are several limitations and no tests, so use with caution**

* There is no way of telling activeadmin when to allow sorting or no
* There is no support for forms
