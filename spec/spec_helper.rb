if ENV['COVERAGE'] == 'true' && RUBY_ENGINE == 'ruby' && RUBY_VERSION == '2.4.0'
  require "simplecov"
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rom-mongo'

begin
  require 'byebug'
rescue LoadError
end

MONGO_URI = 'mongodb://127.0.0.1:27017/rom_mongo'.freeze

Mongo::Logger.logger = Logger.new(nil)

root = Pathname(__FILE__).dirname

# Namespace holding all objects created during specs
module Test
  def self.remove_constants
    constants.each(&method(:remove_const))
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before(:suite) do
    ::Mongo::Client.new(MONGO_URI).database.drop
  end

  config.after do
    Test.remove_constants
  end
end

Dir[root.join('shared/*.rb').to_s].each { |f| require f }
