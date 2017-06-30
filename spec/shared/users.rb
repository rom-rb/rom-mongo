require 'dry-struct'

RSpec.shared_context 'users' do
  let(:users) { container.relations[:users] }
  let(:jane_id) { BSON::ObjectId.new }

  before do
    connection[:users].drop

    configuration.relation(:users) do
      auto_struct true

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

    users.insert(_id: jane_id, name: 'Jane', email: 'jane@doe.org')
    users.insert(name: 'Joe', email: 'a.joe@doe.org')
  end
end
