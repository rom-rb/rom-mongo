module ROM
  module Mongo
    class Relation < ROM::Relation
      forward :insert, :find
    end
  end
end
