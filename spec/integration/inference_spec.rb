require 'spec_helper'
require 'rom-repository'

RSpec.describe 'relation inference' do
  include_context 'database'

  before do
    connection.database[:posts].create
    connection.database[:tasks].create
  end

  after do
    connection.database[:posts].drop
    connection.database[:tasks].drop
  end

  it 'infers all relations by default' do
    expect(container.relation(:posts)).to be_kind_of(ROM::Mongo::Relation)
    expect(container.relation(:tasks)).to be_kind_of(ROM::Mongo::Relation)
  end

  it 'infers configured relations' do
    configuration.config.gateways.default.inferrable_relations = [:posts]

    expect(container.relations.elements.key?(:tasks)).to be(false)
    expect(container.relation(:posts)).to be_kind_of(ROM::Mongo::Relation)
  end

  it 'skips configured relations' do
    configuration.config.gateways.default.not_inferrable_relations = [:posts]

    expect(container.relations.elements.key?(:posts)).to be(false)
    expect(container.relation(:tasks)).to be_kind_of(ROM::Mongo::Relation)
  end
end
