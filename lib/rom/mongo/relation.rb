require 'rom/plugins/relation/key_inference'

module ROM
  module Mongo
    class Relation < ROM::Relation
      adapter :mongo

      use :key_inference

      forward :insert, :find, :only, :without, :skip, :limit, :where
    end
  end
end
