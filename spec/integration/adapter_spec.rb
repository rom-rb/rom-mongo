require 'spec_helper'

require 'virtus'

describe 'Mongo adapter' do
  subject(:rom) { setup.finalize }

  let(:setup) { ROM.setup(mongo: 'mongo://127.0.0.1:27017/test') }

  after do
    rom.mongo.connection.drop
  end

  before do
    setup.schema do
      base_relation(:users) do
        repository :mongo

        attribute "_id"
        attribute "name"
        attribute "email"
      end
    end

    setup.relation(:users) do
      def by_name(name)
        find(name: name)
      end
    end

    user_model = Class.new do
      include Virtus.model

      attribute :id, String
      attribute :name, String
      attribute :email, String
    end

    setup.mappers do
      define(:users) do
        model(user_model)

        attribute :id, from: '_id'
      end
    end

    rom.schema.users.insert(name: 'Jane', email: 'jane@doe.org')
  end

  describe 'env#read' do
    it 'returns mapped object' do
      jane = rom.read(:users).by_name('Jane').to_a.first

      expect(jane.id).to eql(rom.schema.users.find(name: 'Jane').one['_id'].to_s)
      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end
  end

  describe 'adapter#dataset?' do
    it 'returns true if a collection exists' do
      expect(rom.mongo.adapter.dataset?(:users)).to be(true)
    end

    it 'returns false if a does not collection exist' do
      expect(rom.mongo.adapter.dataset?(:not_here)).to be(false)
    end
  end
end
