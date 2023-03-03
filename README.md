# Active Admin Resource

Adapter for [ActiveResource](https://github.com/rails/activeresource) to allow integration
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

## Configuration

TODO

### Limitations and Poorly tested cases

As explained before, there are several limitations and poorly tested cases in the current version:

* Batch actions are not supported
* POST, PUT and DELETE actions are not tested well and may have issues
