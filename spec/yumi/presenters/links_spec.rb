require 'spec_helper'

describe Yumi::Presenters::Links do

  let(:links) { [:self] }

  let(:options) do
    {
      url: BASE_URL,
      resource: resource,
      names: { plural: 'resources' },
      links: links
    }
  end

  let(:klass) { Yumi::Presenters::Links.new(options) }

  describe '#to_json_api' do

    context 'when collection' do

      let(:resource) { [OpenStruct.new({ id: '1' })] }

      it 'returns /resources' do
        expect(klass.to_json_api).to eq({
          self: "#{BASE_URL}/resources"
        })
      end

    end

    context 'when single resource' do

      let(:resource) { OpenStruct.new({ id: '1' }) }

      it 'returns /resources/1' do
        expect(klass.to_json_api).to eq({
          self: "#{BASE_URL}/resources/1"
        })
      end

    end

  end

end
