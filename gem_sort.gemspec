$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gem_sort/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gem_sort"
  s.version     = GemSort::VERSION
  s.authors     = ["kozo yamagata"]
  s.email       = ["tune002@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GemSort."
  s.description = "TODO: Description of GemSort."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
