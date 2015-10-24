module ROM
  module Mongo
    class Relation < ROM::Relation
      adapter :mongo

      forward :insert, :find, :only, :without, :skip, :limit, :where
    end
  end
end
