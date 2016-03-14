require 'spec_helper'

describe Yumi::Presenters::Data do

  class MyDataResource
    def id
      '1'
    end
  end

  let(:resource) { MyDataResource.new }

  let(:options) do
    {
      resource: resource,
      names: { plural: 'resources' },
    }
  end

  let(:klass) { Yumi::Presenters::Data.new(options) }

  before do
    allow_any_instance_of(Yumi::Presenters::Attributes).to receive(:to_json_api).and_return('attributes')
    allow_any_instance_of(Yumi::Presenters::Links).to receive(:to_json_api).and_return('links')
    allow_any_instance_of(Yumi::Presenters::Relationships).to receive(:to_json_api).and_return('relationships')
  end

  describe '#to_json_api' do

    it 'generates the data hash' do
      expect(klass.to_json_api).to eq({
        type: 'resources',
        id: '1',
        attributes: 'attributes',
        links: 'links',
        relationships: 'relationships'
      })
    end

  end

end
