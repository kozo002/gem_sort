$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gem_sort/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gem_sort"
  s.version     = GemSort::VERSION
  s.authors     = ["kozo yamagata"]
  s.email       = ["tune002@gmail.com"]
  s.homepage    = "https://github.com/kozo002/gem_sort"
  s.summary     = "Sorting your gems in Gemfile (for Rails)"
  s.description = "Sorting your gems in Gemfile (for Rails)"
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"
end
