# spec/yumi/presenters/attributes_spec.rb
require 'spec_helper'

describe Yumi::Presenters::Attributes do

  let(:attributes) { [:description, :slug] }
  let(:presenter) { OpenStruct.new({}) }
  let(:resource) { OpenStruct.new({ description: "I'm a resource.", slug: 'whatever' }) }


  let(:options) do
    {
      attributes: attributes,
      resource: resource,
      presenter: presenter
    }
  end

  let(:klass) { Yumi::Presenters::Attributes.new(options) }

  describe '#to_json_api' do

    context 'without overrides' do

      it 'generates the hash only with the resource attributes' do
        expect(klass.to_json_api).to eq({
          description: "I'm a resource.",
          slug: 'whatever'
        })
      end

    end

    context 'with overrides' do

      let(:presenter) { OpenStruct.new({ description: "I'm a presenter." }) }

      it 'outputs the hash with the description overridden' do
        expect(klass.to_json_api).to eq({
          description: "I'm a presenter.",
          slug: 'whatever'
        })
      end

    end

  end

end
