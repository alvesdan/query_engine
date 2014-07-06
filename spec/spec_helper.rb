require 'simplecov'
SimpleCov.start

require 'rspec'
require 'pry'
require_relative '../lib/query_engine'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
end
