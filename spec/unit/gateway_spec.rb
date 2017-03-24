require 'spec_helper'

require 'rom/lint/spec'

RSpec.describe ROM::Mongo::Gateway do
  it_behaves_like 'a rom gateway' do
    let(:identifier) { :mongo }
    let(:gateway) { ROM::Mongo::Gateway }
    let(:uri) { MONGO_URI }
  end
end
