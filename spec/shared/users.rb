require 'virtus'

RSpec.shared_context 'users' do
  let(:container) { ROM.container(configuration) }
  let(:configuration) { ROM::Configuration.new(:mongo, connection) }
  let(:connection) { ::Mongo::Client.new(MONGO_URI) }

  let(:users) { container.relation(:users) }
  let(:jane_id) { BSON::ObjectId.new }

  before do
    connection[:users].drop

    configuration.relation(:users) do
      schema do
        # TODO: we need ROM::Mongo::Types (similar to ROM::SQL::Types)
        attribute :_id, ROM::Types.Definition(BSON::ObjectId)
        attribute :name, ROM::Types::String
        attribute :email, ROM::Types::String
      end

      def by_name(name)
        find(name: name)
      end

      def all
        find
      end
    end

    configuration.commands(:users) do
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

    configuration.mappers do
      define(:users) do
        model(user_model)

        register_as :model

        attribute :id, from: '_id'
        attribute :name, from: 'name'
        attribute :email, from: 'email'
      end
    end

    container.relations.users.insert(_id: jane_id, name: 'Jane', email: 'jane@doe.org')
    container.relations.users.insert(name: 'Joe', email: 'joe@doe.org')
  end
end
