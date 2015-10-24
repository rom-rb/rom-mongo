require 'bson'

require 'rom/commands'

module ROM
  module Mongo
    module Commands
      class Create < ROM::Commands::Create
        adapter :mongo

        def collection
          relation.dataset
        end

        def execute(document)
          collection.insert(document)
          [document]
        end
      end

      class Update < ROM::Commands::Update
        adapter :mongo

        def collection
          relation.dataset
        end

        def execute(attributes)
          collection.update_all('$set' => attributes)
          collection.to_a
        end
      end

      class Delete < ROM::Commands::Delete
        adapter :mongo

        def execute
          removed = relation.to_a
          relation.dataset.remove_all
          removed
        end
      end
    end
  end
end
