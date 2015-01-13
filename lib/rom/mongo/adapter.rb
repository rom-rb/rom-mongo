require 'moped'

require 'rom/adapter'

require 'rom/mongo/dataset'
require 'rom/mongo/commands'

module ROM
  module Mongo
    class Adapter < ROM::Adapter
      def self.schemes
        [:mongo]
      end

      attr_reader :collections

      def setup
        @connection = Moped::Session.new(["#{uri.host}:#{uri.port}"])
        @connection.use uri.path.gsub('/', '')
        @collections = {}
      end

      def [](name)
        collections.fetch(name)
      end

      def dataset(name)
        collections[name] = Dataset.new(connection[name])
      end

      def dataset?(name)
        connection.collection_names.include?(name.to_s)
      end

      def command_namespace
        Mongo::Commands
      end
    end
  end
end
