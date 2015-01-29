require 'bson'

require 'rom/commands'

module ROM
  module Mongo
    module Commands
      module Create
        include ROM::Commands::Create

        def collection
          relation
        end

        def execute(document)
          collection.insert(document)
          [document]
        end
      end

      module Update
        include ROM::Commands::Update

        def collection
          relation
        end

        def execute(attributes)
          collection.update_all('$set' => attributes)
          collection.to_a
        end
      end

      module Delete
        include ROM::Commands::Delete

        def execute
          removed = target.to_a
          target.remove_all
          removed
        end
      end
    end
  end
end
