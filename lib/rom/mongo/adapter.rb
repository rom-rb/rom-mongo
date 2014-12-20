module ROM
  module Mongo

    class Adapter < ROM::Adapter

      def self.schemes
        [:mongo]
      end

      module RelationInclusion

        def header
          dataset.header
        end

      end

      class Dataset
        include Charlatan.new(:collection, kind: Moped::Query)
        include Equalizer.new(:collection, :header)

        alias_method :query, :collection

        def initialize(collection, header)
          super
          @header = header unless query?
        end

        def header
          query? ? query.operation.fields : @header
        end

        def each(&block)
          collection.find.each(&block)
        end

        def query?
          collection.is_a?(Moped::Query)
        end
      end

      attr_reader :collections

      def initialize(*args)
        super
        @connection = Moped::Session.new(["#{uri.host}:#{uri.port}"])
        @connection.use uri.path.gsub('/', '')
        @collections = {}
      end

      def [](name)
        collections.fetch(name)
      end

      def dataset(name, header)
        collections[name] = Dataset.new(connection[name], header)
      end

      def dataset?(name)
        connection.collection_names.include?(name.to_s)
      end

      def command_namespace
        Mongo::Commands
      end

      def extend_relation_class(klass)
        klass.send(:include, RelationInclusion)
      end

      ROM::Adapter.register(self)
    end

  end
end
