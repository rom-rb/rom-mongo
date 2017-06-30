require 'rom/schema'

module ROM
  module Mongo
    class Schema < ROM::Schema
      # @api public
      def call(relation)
        relation.new(relation.dataset.only(map(&:name)), schema: self)
      end
    end
  end
end
