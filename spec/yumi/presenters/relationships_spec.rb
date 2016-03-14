require 'spec_helper'

describe Yumi::Presenters::Relationships do

  class MyRelationshipsGarage
    def id
      '1'
    end

    def skates
      ['lamborghini', 'ferrari', 'ford']
    end

    def bicycles
      ['ducati', 'yamaha']
    end
  end

  # Since we're testing this class in isolation
  # we need to replicate a base class to inherit from
  module Yumi
    module RelationshipsTests
      class Base
        def initialize(a, b, c)
        end
        def as_relationship
        end
      end
    end
  end

  module Presenters
    class Bicycle < Yumi::RelationshipsTests::Base; end
    class Skate < Yumi::RelationshipsTests::Base; end
  end

  let(:options) do
    {
      url: BASE_URL,
      resource: MyRelationshipsGarage.new,
      names: { plural: 'garages' },
      relationships: [:bicycles, :skates]
    }
  end

  let(:klass) { Yumi::Presenters::Relationships.new(options) }

  before do
    allow_any_instance_of(Presenters::Bicycle).to receive(:as_relationship).and_return('bicycles!')
    allow_any_instance_of(Presenters::Skate).to receive(:as_relationship).and_return('skates!')
  end

  describe '#to_json_api' do

    it 'builds the relationships hash' do
      expect(klass.to_json_api).to eq({
        bicycles: 'bicycles!',
        skates: 'skates!'
      })
    end

  end

  describe '#prefix' do

    it 'returns the presenter' do
      expect(klass.send(:prefix)).to eq('garages/1/')
    end

  end

  describe '#presenter' do

    it 'returns the Presenters::Car presenter' do
      expect(klass.send(:presenter, :bicycles)).to eq(Presenters::Bicycle)
    end

  end

end
