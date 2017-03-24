require 'rom/plugins/relation/key_inference'

module ROM
  module Mongo
    class Relation < ROM::Relation
      # @api private
      def self.inherited(klass)
        super

        klass.auto_curry :by_pk
      end

      adapter :mongo

      use :key_inference

      forward :insert, :find, :only, :without, :skip, :limit, :where

      # @!method by_pk(id)
      #   Return a relation restricted by _id
      #
      #   @param id [BSON::ObjectId] Document's PK value
      #
      #   @return [Mongo::Relation]
      #
      #   @api public
      def by_pk(id)
        find(_id: id)
      end
    end
  end
end
