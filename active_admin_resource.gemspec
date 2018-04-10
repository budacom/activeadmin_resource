Gem::Specification.new do |s|
  s.name        = 'active_admin_resource'
  s.version     = '0.1.2'
  s.date        = '2018-03-23'
  s.summary     = "ActiveResource for ActiveAdmin"
  s.description = "An adapter for using ActiveResource with ActiveAdmin"
  s.authors     = ["Alejandro Echeverria"]
  s.email       = ["alejandro.echeverria@buda.com"]
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = "https://github.com/SurBTC/authograph"
  s.license     = 'MIT'

  s.add_dependency "activeadmin"
  s.add_dependency "activeresource"
  s.add_dependency "authograph"

end