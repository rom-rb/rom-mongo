module ROM
  module Mongo

    class Adapter < ROM::Adapter
      attr_reader :connection

      def self.schemes
        [:mongo]
      end

      class Dataset
        include Charlatan.new(:collection, kind: Moped::Query)

        def each(&block)
          collection.find.each(&block)
        end
      end

      def initialize(*args)
        super
        @connection = Moped::Session.new(["#{uri.host}:#{uri.port}"])
        @connection.use uri.path.gsub('/', '')
      end

      def [](name)
        Dataset.new(connection[name])
      end

      def dataset?(name)
        connection.collection_names.include?(name.to_s)
      end

      def command_namespace
        Mongo::Commands
      end

      ROM::Adapter.register(self)
    end

  end
end
