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
        creds, host_uri = uri.split('@')
        user, password = creds.split(':')

        if host_uri
          host, database = host_uri.split('/')

          options = {
            database: database
          }

          if user
            options[:user] = user
          end

          if password
            options[:password] = password
          end
        else
          host, database = uri.split('/')
          options = { database: database }
        end

        @connection = ::Mongo::Client.new([host], options)
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
