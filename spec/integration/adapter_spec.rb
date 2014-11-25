require 'spec_helper'

require 'virtus'

describe 'Mongo adapter' do
  let(:setup) { ROM.setup(mongo: 'mongo://127.0.0.1:27017/test') }
  let(:rom) { setup.finalize }

  after do
    rom.mongo.connection.drop
  end

  it 'works' do
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

      attribute :_id, String
      attribute :name, String
      attribute :email, String
    end

    setup.mappers do
      define(:users) do
        model(user_model)
      end
    end

    rom.schema.users.insert(name: 'Jane', email: 'jane@doe.org')

    jane = rom.read(:users).by_name('Jane').to_a.first

    expect(jane._id).to eql(rom.schema.users.find(name: 'Jane').one['_id'].to_s)
    expect(jane.name).to eql('Jane')
    expect(jane.email).to eql('jane@doe.org')
  end
end
