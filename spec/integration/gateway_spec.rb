require 'spec_helper'
require 'rom-repository'

RSpec.describe 'Mongo gateway' do
  include_context 'database'
  include_context 'users'

  let(:gateway) { container.gateways[:default] }

  describe 'env#relation' do
    it 'returns mapped object' do
      jane = users.as(:model).by_name('Jane').one!

      expect(jane.id)
        .to eql(container.relation(:users) { |r| r.find(name: 'Jane') }.one['_id'].to_s)

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
        .to eql(container.relation(:users) { |r| r.find(name: 'Jane') }.one['_id'].to_s)

      expect(jane.name).to eql('Jane')
      expect(jane.email).to eql('jane@doe.org')
    end

    it 'uses #by_pk for update commands' do
      repo.update(jane_id, name: 'Jane Doe')

      expect(repo.users.by_pk(jane_id).one!.name).to eql('Jane Doe')
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
    let(:commands) { container.command(:users) }

    describe 'create' do
      it 'inserts a document into collection' do
        id = BSON::ObjectId.new

        result = commands.try do
          commands.create.call(_id: id, name: 'joe', email: 'joe@doe.org')
        end

        expect(result)
          .to match_array([{ _id: id, name: 'joe', email: 'joe@doe.org' }])
      end
    end

    describe 'update' do
      it 'updates a document in the collection' do
        jane = container.relation(:users).as(:model).by_name('Jane').one!

        result = commands.try do
          commands.update.by_name('Jane').call(email: 'jane.doe@test.com')
        end

        expect(result).to match_array(
          [{ '_id' => BSON::ObjectId.from_string(jane.id),
             'name' => 'Jane',
             'email' => 'jane.doe@test.com' }]
        )
      end
    end

    describe 'delete' do
      it 'deletes documents from the collection' do
        jane = container.relation(:users).as(:model).by_name('Jane').one!
        joe = container.relation(:users).as(:model).by_name('Joe').one!

        result = commands.try { commands.delete.by_name('Joe') }

        expect(result).to match_array(
          [{ '_id' => BSON::ObjectId.from_string(joe.id),
             'name' => 'Joe',
             'email' => 'joe@doe.org' }]
        )

        expect(container.relation(:users).as(:model).all).to match_array([jane])
      end
    end
  end
end
