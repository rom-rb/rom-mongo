require 'spec_helper'

require 'rom/lint/spec'

describe ROM::Mongo::Repository do
  it_behaves_like 'a rom repository' do
    let(:identifier) { :mongo }
    let(:repository) { ROM::Mongo::Repository }
    let(:uri) { '127.0.0.1:27017/test' }
  end
end
