require 'origin'

module ROM
  module Mongo
    class Dataset
      class Criteria
        include Origin::Queryable
      end

      def initialize(collection, criteria = Criteria.new)
        @collection = collection
        @criteria = criteria
      end

      attr_reader :collection

      attr_reader :criteria

      def find(criteria = {})
        Dataset.new(collection, Criteria.new.where(criteria))
      end

      def to_a
        view.to_a
      end

      # @api private
      def each
        view.each { |doc| yield(doc) }
      end

      def insert(data)
        collection.insert_one(data)
      end

      def update_all(attributes)
        view.update_many(attributes)
      end

      def remove_all
        view.delete_many
      end

      def where(doc)
        dataset(criteria.where(doc))
      end

      def only(fields)
        dataset(criteria.only(fields))
      end

      def without(fields)
        dataset(criteria.without(fields))
      end

      def limit(limit)
        dataset(criteria.limit(limit))
      end

      def skip(value)
        dataset(criteria.skip(value))
      end

      private

      def view
        with_options(collection.find(criteria.selector), criteria.options)
      end

      def dataset(criteria)
        Dataset.new(collection, criteria)
      end

      # Applies given options to the view
      #
      # @api private
      def with_options(view, options)
        map = {fields: :projection}
        options.each do |option, value|
          option = map.fetch(option, option)
          view = view.send(option, value) if view.respond_to?(option)
        end
        view
      end
    end
  end
end
