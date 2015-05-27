require 'charlatan'

module ROM
  module Mongo
    class Dataset
      include Charlatan.new(:collection, kind: Moped::Query)

      # @api private
      def each
        collection.each { |doc| yield(doc) }
      end
    end
  end
end
