$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'query_engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'query_engine'
  s.version     = QueryEngine::VERSION
  s.authors     = ['Driftrock']
  s.email       = ['dev@driftrock.com']
  s.homepage    = ''
  s.summary     = ''
  s.description = 'Matches a hash using a mongodb like query engine'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'simplecov'
end
