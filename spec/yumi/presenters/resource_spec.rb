require 'spec_helper'

describe Yumi::Presenters::Resource do

  class MySuperResource; end

  let(:links) { [:self] }
  let(:options) { { resource: resource, names: { plural: 'resources' } } }
  let(:klass) { Yumi::Presenters::Resource.new(options) }

  before do
    allow_any_instance_of(Yumi::Presenters::Data).to receive(:to_json_api).and_return('success!')
  end

  describe '#to_json_api' do

    context 'when collection' do

      let(:resource) { [MySuperResource.new, MySuperResource.new] }

      it 'returns ["success!", "success!"]' do
        expect(klass.to_json_api).to eq(['success!', 'success!'])
      end

    end

    context 'when single resource' do

      let(:resource) { MySuperResource.new }

      it 'returns "success"' do
        expect(klass.to_json_api).to eq('success!')
      end

    end

  end

end
