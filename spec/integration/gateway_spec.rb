require 'rom/repository'

RSpec.describe 'Mongo gateway' do
  include_context 'database'
  include_context 'users'

  let(:gateway) { container.gateways[:default] }

  describe 'auto-struct' do
    it 'returns mapped object' do
      jane = users.by_name('Jane').one!

      expect(jane._id.to_s).to eql(users.find(name: 'Jane').one._id.to_s)

      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end
  end

  describe 'with a repository' do
    let(:repo) do
      Class.new(ROM::Repository[:users]) do
        commands :create, update: :by_pk
      end.new(container)
    end

    it 'returns auto-mapped structs' do
      jane = repo.users.by_name('Jane').one!

      expect(jane._id.to_s)
        .to eql(users.find(name: 'Jane').one['_id'].to_s)

      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end

    it 'uses #by_pk for update commands' do
      repo.update(jane_id, name: 'Jane Doe')

      expect(users.by_pk(jane_id).one!.name).to eql('Jane Doe')
    end
  end

  describe 'gateway#dataset?' do
    it 'returns true if a collection exists' do
      expect(gateway.dataset?(:users)).to be(true)
    end

    it 'returns false if a does not collection exist' do
      expect(gateway.dataset?(:not_here)).to be(false)
    end
  end

  describe 'commands' do
    let(:commands) { container.commands[:users] }

    describe 'create' do
      it 'inserts a document into collection' do
        id = BSON::ObjectId.new

        result = commands.try do
          commands.create.call(_id: id, name: 'joe', email: 'a.joe@doe.org')
        end

        expect(result)
          .to match_array([{ _id: id, name: 'joe', email: 'a.joe@doe.org' }])
      end
    end

    describe 'update' do
      it 'updates a document in the collection' do
        jane = users.by_name('Jane').one!

        result = commands.try do
          commands.update.by_name('Jane').call(email: 'jane.doe@test.com')
        end

        expect(result).to match_array(
          [{ '_id' => BSON::ObjectId.from_string(jane._id),
             'name' => 'Jane',
             'email' => 'jane.doe@test.com' }]
        )
      end
    end

    describe 'delete' do
      it 'deletes documents from the collection' do
        jane = users.by_name('Jane').one!
        joe = users.by_name('Joe').one!

        result = commands.delete.by_name('Joe').call

        expect(result.map(&:to_h)).to match_array(
          [{ _id: BSON::ObjectId.from_string(joe._id),
             name: 'Joe',
             email: 'a.joe@doe.org' }]
        )

        expect(users.all).to match_array([jane])
      end
    end
  end
end
