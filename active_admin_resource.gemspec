Gem::Specification.new do |s|
  s.name        = 'active_admin_resource'
  s.version     = '1.0.0'
  s.date        = '2023-03-03'
  s.summary     = "ActiveResource for ActiveAdmin"
  s.description = "An adapter for using ActiveResource with ActiveAdmin"
  s.authors     = ["Alejandro Echeverria"]
  s.email       = ["alejandro.echeverria@buda.com"]
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = "https://github.com/budacom/activeadmin_resource"
  s.license     = 'MIT'

  s.add_dependency "activeadmin"
  s.add_dependency "activeresource"
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
end
