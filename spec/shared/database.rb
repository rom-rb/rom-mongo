RSpec.shared_context 'database' do
  let(:container) { ROM.container(configuration) }
  let(:configuration) { ROM::Configuration.new(:mongo, connection) }
  let(:connection) { ::Mongo::Client.new(MONGO_URI) }

  let(:users) { container.relations[:users].with(auto_struct: true) }
  let(:jane_id) { BSON::ObjectId.new }
end
