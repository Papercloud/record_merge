$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "record_merge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "record_merge"
  s.version     = RecordMerge::VERSION
  s.authors     = ["William Porter"]
  s.email       = ["dawilster143@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RecordMerge."
  s.description = "TODO: Description of RecordMerge."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
end
