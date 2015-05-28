$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "record_merge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "record_merge"
  s.version     = RecordMerge::VERSION
  s.authors     = ["William Porter"]
  s.email       = ["wp@papercloud.com.au"]
  s.homepage    = "http://papercloud.com.au"
  s.summary     = "Merges ActiveRecord recods"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2"

  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'awesome_print'
end
