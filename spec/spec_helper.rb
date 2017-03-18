if ENV['COVERAGE'] == 'true' && RUBY_ENGINE == 'ruby' && RUBY_VERSION == '2.4.0'
  require "simplecov"
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rom-mongo'

Mongo::Logger.logger = Logger.new(nil)

root = Pathname(__FILE__).dirname

Dir[root.join('shared/*.rb').to_s].each { |f| require f }

RSpec.configure do |config|
  config.before do
    @constants = Object.constants
  end

  config.after do
    added_constants = Object.constants - @constants
    added_constants.each { |name| Object.send(:remove_const, name) }
  end
end
