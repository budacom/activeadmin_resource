Gem::Specification.new do |s|
  s.name        = 'active_admin_resource'
  s.version     = '0.1.4'
  s.date        = '2018-04-18'
  s.summary     = "ActiveResource for ActiveAdmin"
  s.description = "An adapter for using ActiveResource with ActiveAdmin"
  s.authors     = ["Alejandro Echeverria"]
  s.email       = ["alejandro.echeverria@buda.com"]
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = "https://github.com/budacom/activeadmin_resource"
  s.license     = 'MIT'

  s.add_dependency "activeadmin"
  s.add_dependency "activeresource"
  s.add_dependency "authograph"
  s.add_dependency 'enumerize', '~> 2.2'
  s.add_dependency 'money-rails', '~> 1.5'
  s.add_dependency 'monetize', '~> 1.3.0'
  s.add_dependency 'money', '~> 6.6'
  s.add_dependency 'formtastic'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end
