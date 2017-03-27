require 'mongo'
require 'uri'

require 'rom/gateway'

require 'rom/mongo/dataset'
require 'rom/mongo/commands'

module ROM
  module Mongo
    class Gateway < ROM::Gateway
      adapter :mongo

      attr_reader :collections

      # @!attribute [r] options
      #   @return [Hash] Gateway options
      attr_reader :options

      # Initialize an Mongo gateway
      #
      # Gateways are typically initialized via ROM::Configuration object, gateway constructor
      # arguments such as URI and options are passed directly to this constructor
      #
      # @overload initialize(uri)
      #   Connects to a database via URI
      #
      #   @example
      #     ROM.container(:mongo, 'mongodb://127.0.0.1:27017/db_name')
      #
      #   @param [String] uri connection URI
      #
      # @overload initialize(uri, options)
      #   Connects to a database via URI and options
      #
      #   @example
      #     ROM.container(:mongo, 'mongodb://127.0.0.1:27017/db_name', inferrable_relations: %i[users posts])
      #
      #   @param [String,Symbol] uri connection URI
      #
      #   @param [Hash] options connection options
      #
      #   @option options [Array<Symbol>] :inferrable_relations
      #     A list of collection names that should be inferred. If
      #     this is set explicitly to an empty array relations
      #     won't be inferred at all
      #
      #   @option options [Array<Symbol>] :not_inferrable_relations
      #     A list of collection names that should NOT be inferred
      #
      # @overload initialize(connection)
      #   Creates a gateway from an existing database connection.
      #
      #   @example
      #     ROM.container(:mongo, Mongo::Client.new('mongodb://127.0.0.1:27017/db_name'))
      #
      #   @param [Mongo::Client] connection a connection instance
      #
      # @return [Mongo::Gateway]
      #
      # @see https://docs.mongodb.com/ruby-driver/master/ MongoDB driver docs
      #
      # @api public
      def initialize(uri, options = EMPTY_HASH)
        @connection = uri.is_a?(::Mongo::Client) ? uri : ::Mongo::Client.new(uri, options)
        @collections = {}
      end

      # List of defined collections
      #
      # @return [Array<Symbol>] An array with dataset names
      #
      # @api private
      def schema
        connection.database.collection_names.map(&:to_sym)
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
