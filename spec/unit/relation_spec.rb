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
end
