require 'charlatan'

module ROM
  module Mongo
    class Dataset
      include Charlatan.new(:collection, kind: Moped::Query)
    end
  end
end
