require 'mongo'
require 'uri'

require 'rom/gateway'

require 'rom/mongo/dataset'
require 'rom/mongo/commands'

module ROM
  module Mongo
    class Gateway < ROM::Gateway
      attr_reader :collections

      def initialize(uri)
        @connection = ::Mongo::Client.new(uri)
        @collections = {}
      end

      def [](name)
        collections.fetch(name)
      end

      def dataset(name)
        collections[name] = Dataset.new(connection[name])
      end

      def dataset?(name)
        connection.database.collection_names.include?(name.to_s)
      end

      def command_namespace
        Mongo::Commands
      end
    end
  end
end
