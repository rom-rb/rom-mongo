RSpec.describe ROM::Mongo::Relation do
  include_context 'database'
  include_context 'users'

  describe '#by_pk' do
    it 'fetches a document by _id' do
      expect(users.by_pk(jane_id).one!).
        to eql(
             '_id' => jane_id,
             'name' => 'Jane',
             'email' => 'jane@doe.org'
           )
    end
  end

  describe '#order' do
    it 'sorts documents' do
      expect(users.order(name: :asc).only(:name).without(:_id).to_a).
        to eql([{'name' => 'Jane',}, {'name' => 'Joe'}])

      expect(users.order(name: :desc).only(:name).without(:_id).to_a).
        to eql([{'name' => 'Joe',}, {'name' => 'Jane'}])
    end

    it 'supports mutli-field sorting' do
      expect(users.order(name: :asc, email: :asc).only(:name).without(:_id).to_a).
        to eql([{'name' => 'Jane',}, {'name' => 'Joe'}])

      expect(users.order(email: :asc, name: :asc).only(:name).without(:_id).to_a).
        to eql([{'name' => 'Joe',}, {'name' => 'Jane'}])
    end
  end
end
