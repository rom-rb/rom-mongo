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

        attribute '_id'
        attribute 'name'
        attribute 'email'
      end
    end

    setup.relation(:users) do
      def by_name(name)
        find(name: name)
      end
    end

    setup.commands(:users) do
      define(:create)
      define(:update)
      define(:delete)
    end

    user_model = Class.new do
      include Virtus.value_object

      values do
        attribute :id, String
        attribute :name, String
        attribute :email, String
      end
    end

    setup.mappers do
      define(:users) do
        model(user_model)

        attribute :id, from: '_id'
      end
    end

    rom.schema.users.insert(name: 'Jane', email: 'jane@doe.org')
    rom.schema.users.insert(name: 'Joe', email: 'joe@doe.org')
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

  describe 'commands' do
    let(:commands) { rom.command(:users) }

    describe 'create' do
      it 'inserts a document into collection' do
        id = BSON::ObjectId.new

        result = commands.try { create(_id: id, name: 'joe', email: 'joe@doe.org') }

        expect(result).to match_array([{ _id: id, name: 'joe', email: 'joe@doe.org' }])
      end
    end

    describe 'update' do
      it 'updates a document in the collection' do
        jane = rom.read(:users).by_name('Jane').first

        result = commands.try { update(:by_name, 'Jane').set(email: 'jane.doe@test.com') }

        expect(result).to match_array(
          [{ '_id' => BSON::ObjectId.from_string(jane.id),
             'name' => 'Jane',
             'email' => 'jane.doe@test.com' }]
        )
      end
    end

    describe 'delete' do
      it 'deletes documents from the collection' do
        jane = rom.read(:users).by_name('Jane').first
        joe = rom.read(:users).by_name('Joe').first

        result = commands.try { delete(:by_name, 'Joe').execute }

        expect(result).to match_array(
          [{ '_id' => BSON::ObjectId.from_string(joe.id),
             'name' => 'Joe',
             'email' => 'joe@doe.org' }]
        )

        expect(rom.read(:users).to_a).to eql([jane])
      end
    end
  end
end
