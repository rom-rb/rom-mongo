module ROM
  module Mongo
    class Relation < ROM::Relation
      forward :insert, :find, :only, :without, :skip, :limit, :where
    end
  end
end
