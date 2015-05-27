require 'charlatan'

module ROM
  module Mongo
    class Dataset
      include Charlatan.new(:collection, kind: ::Mongo::Collection::View)

      # @api private
      def each
        collection.each { |doc| yield(doc) }
      end

      def insert(data)
        collection.insert_one(data)
      end

      def update_all(attributes)
        collection.update_many(attributes)
      end

      def remove_all
        collection.delete_many
      end
    end
  end
end
