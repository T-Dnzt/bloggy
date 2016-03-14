require 'spec_helper'

describe Yumi::Presenters::IncludedResources do

  class MyGarage
    def id
      '1'
    end

    def cars
      [
        OpenStruct.new({id: '123', type: 'lamborghini'}),
        OpenStruct.new({id: '123', type: 'lamborghini2'}),
        OpenStruct.new({id: '234', type: 'ferrari'}),
        OpenStruct.new({id: '345', type: 'ford'})
      ]
    end

    def bikes
      [
        OpenStruct.new({id: '123', type: 'lamborghini'}),
        OpenStruct.new({id: '234', type: 'ferrari'})
      ]
    end
  end

  # Since we're testing this class in isolation
  # we need to replicate a base class to inherit from
  module Yumi
    module IncludedResourcesTests
      class Base
        def initialize(a, b)
        end
        def as_included
        end
      end
    end
  end

  # We need presenters for cars and bikes
  # because this presenter will instantiate them based
  # on the relationship names (:bikes, :cars)
  module Presenters
    class Car < Yumi::IncludedResourcesTests::Base; end
    class Bike < Yumi::IncludedResourcesTests::Base; end
  end

  let(:resource) { MyGarage.new }

  let(:options) do
    {
      url: BASE_URL,
      resource: resource,
      names: { plural: 'garages' },
      relationships: [:cars, :bikes]
    }
  end

  let(:klass) { Yumi::Presenters::IncludedResources.new(options) }

  before do
    allow_any_instance_of(Presenters::Car).to receive(:as_included).and_return('car')
    allow_any_instance_of(Presenters::Bike).to receive(:as_included).and_return('bike')
  end

  describe '#to_json_api' do

    context 'when resource is a collection' do

      let(:resource) { [MyGarage.new, MyGarage.new] }

      it 'returns an array of included resources without duplicates' do
        expect(klass.to_json_api).to eq(['car', 'car', 'car', 'bike', 'bike'])
      end

    end

    context 'when resource is a single resource' do

      it 'returns an array of included resources without duplicates' do
        expect(klass.to_json_api).to eq(['car', 'car', 'car', 'bike', 'bike'])
      end
    end

  end

  describe '#presenter' do

    it 'returns the Presenters::Car presenter' do
      expect(klass.send(:presenter, :cars)).to eq(Presenters::Car)
    end

  end

end
