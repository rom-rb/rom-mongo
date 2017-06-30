require 'rom/relation'
require 'rom/mongo/struct'
require 'rom/mongo/schema'

module ROM
  module Mongo
    class Relation < ROM::Relation
      adapter :mongo

      struct_namespace ROM::Mongo

      schema_class Mongo::Schema

      forward :insert, :find, :skip, :limit, :where, :order

      # @api private
      def self.view_methods
        super + [:by_pk]
      end

      # @api public
      def only(*fields)
        schema.project(*fields).(self)
      end

      # @api public
      def without(*fields)
        schema.project(*(schema.map(&:name) - fields)).(self)
      end

      # @!method by_pk(id)
      #   Return a relation restricted by _id
      #
      #   @param id [BSON::ObjectId] Document's PK value
      #
      #   @return [Mongo::Relation]
      #
      #   @api public
      auto_curry def by_pk(id)
        find(_id: id)
      end
    end
  end
end
