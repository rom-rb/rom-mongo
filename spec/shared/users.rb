require 'dry-struct'

RSpec.shared_context 'users' do
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

    user_model = Class.new(Dry::Struct) do
      attribute :id, 'coercible.string'
      attribute :name, 'strict.string'
      attribute :email, 'strict.string'
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
    container.relations.users.insert(name: 'Joe', email: 'a.joe@doe.org')
  end
end
