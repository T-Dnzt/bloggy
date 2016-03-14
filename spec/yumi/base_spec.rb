# spec/yumi/base_spec.rb
require 'spec_helper'

describe Yumi::Base do

  class Game
    attr_accessor :id, :title, :rating,
                  :levels, :characters

    def initialize(id)
      @id = id
      @title = 'Super Game'
      @rating = '10'
      @levels = [Level.new('1', 10), Level.new('2', 20)]
      @characters = [Character.new('1')]
    end

  end

  class Level
    attr_accessor :id, :title, :number

    def initialize(id, number)
      @id = id
      @title = 'Super Level'
      @number = id
    end

  end

  class Character
    attr_accessor :id, :name, :level_number

    def initialize(id)
      @id = id
      @name = 'John Doe'
      @level_number = 1
    end

  end

  module Presenters
    class Game < ::Yumi::Base
      meta({ some: 'stuff' })
      attributes :title, :rating
      has_many :levels, :characters
      links :self
    end

    class Level < ::Yumi::Base
      attributes :title, :number
      links :self
    end

    class Character < ::Yumi::Base
      attributes :name, :level_number
      links :self
    end
  end

  let(:url) { BASE_URL }
  let(:resource) { Game.new(1) }
  let(:resources) { [Game.new(1), Game.new(2)] }
  let(:presenter) { Presenters::Game.new(url, resource) }
  let(:meta) { { some: 'stuff' } }

  describe '#initialize' do

    it 'creates the @options hash' do
      expect(presenter.instance_variable_get("@options")).to eq({
        presenter: presenter,
        url: url,
        resource: resource,
        prefix: nil,
        attributes: [:title, :rating],
        links: [:self],
        meta: meta,
        relationships: [:levels, :characters],
        names: {
          demodulized: 'Game',
          singular: 'game',
          plural: 'games'
        }
      })
    end

  end

  describe '#as_json_api' do

    let(:game1) { {
      type: 'games',
      id: '1',
      attributes: {
        title: 'Super Game',
        rating: '10'},
        links: { self: 'http://example.org:80/api/v1/games/1' },
        relationships: {
          levels: {
            data: [{ type: 'levels', id: '1' }, { type: 'levels', id: '2' }],
            links: {
              self: 'http://example.org:80/api/v1/games/1/relationships/levels',
              related: 'http://example.org:80/api/v1/games/1/levels'
            }
          },
          characters: {
            data: [{ type: 'characters', id: '1' }],
            links: {
              self: 'http://example.org:80/api/v1/games/1/relationships/characters',
              related: 'http://example.org:80/api/v1/games/1/characters'
            }
          }
        }
    } }
    let(:game2) { {
      type: 'games',
      id: '2',
      attributes: {
        title: 'Super Game',
        rating: '10'},
        links: { self: 'http://example.org:80/api/v1/games/2' },
        relationships: {
          levels: {
            data: [{ type: 'levels', id: '1' }, { type: 'levels', id: '2' }],
            links: {
              self: 'http://example.org:80/api/v1/games/2/relationships/levels',
              related: 'http://example.org:80/api/v1/games/2/levels'
            }
          },
          characters: {
            data: [{ type: 'characters', id: '1' }],
            links: {
              self: 'http://example.org:80/api/v1/games/2/relationships/characters',
              related: 'http://example.org:80/api/v1/games/2/characters'
            }
          }
        }
    } }
    let(:included) { [
      {
        type: 'levels',
        id: '1',
        attributes: { title: 'Super Level', number: '1' },
        links: { self: 'http://example.org:80/api/v1/levels/1' }
      },
      {
        type: 'levels',
        id: '2',
        attributes: { title: 'Super Level', number: '2'},
        links: {self: 'http://example.org:80/api/v1/levels/2'}
      },
      {
        type: 'characters',
        id: '1',
        attributes: { name: 'John Doe', level_number: 1 },
        links: { self: 'http://example.org:80/api/v1/characters/1' }
      }
    ] }

    context 'when resource is a collection' do

      it 'correctly generates the meta section' do
        expect(Presenters::Game.new(url, resources).as_json_api[:meta]).to eq(meta)
      end

      it 'correctly generates the links section' do
        expect(Presenters::Game.new(url, resources).as_json_api[:links]).to eq({
          self: 'http://example.org:80/api/v1/games'
        })
      end

      it 'correctly generates the data section' do
        expect(Presenters::Game.new(url, resources).as_json_api[:data]).to eq([game1, game2])
      end

      it 'correctly generates the included section' do
        expect(Presenters::Game.new(url, resources).as_json_api[:included]).to eq(included)
      end

    end

    context 'when resource is a single resource' do

      it 'correctly generates the meta section' do
        expect(Presenters::Game.new(url, resource).as_json_api[:meta]).to eq(meta)
      end

      it 'correctly generates the links section' do
        expect(Presenters::Game.new(url, resource).as_json_api[:links]).to eq({
          self: 'http://example.org:80/api/v1/games/1'
        })
      end

      it 'correctly generates the data section' do
        expect(Presenters::Game.new(url, resource).as_json_api[:data]).to eq(game1)
      end

      it 'correctly generates the included section' do
        expect(Presenters::Game.new(url, resource).as_json_api[:included]).to eq(included)
      end

    end

  end

  describe '#as_relationship' do

    it 'generates the relationship hash' do
      expect(Presenters::Game.new(url, resources).as_relationship).to eq({
        data: [{ type: 'games', id: '1' }, { type: 'games', id: '2' }],
        links: {
          self: "#{url}/relationships/games",
          related: "#{url}/games"
        }
      })
    end

    context 'with a prefix' do

      it 'generates the relationship hash' do
        expect(Presenters::Game.new(url, resources, 'cool_prefix/').as_relationship).to eq({
          data: [{ type: 'games', id: '1' }, { type: 'games', id: '2' }],
          links: {
            self: "#{url}/cool_prefix/relationships/games",
            related: "#{url}/cool_prefix/games"
          }
        })
      end

    end

  end

  describe '#as_included' do

    it 'generates the included hash' do
      expect(Presenters::Game.new(url, resource).as_included).to eq({
        type: 'games',
        id: '1',
        attributes: {
          title: 'Super Game',
          rating: '10'
        },
        links: {
          self: "#{url}/games/1"
        }
      })
    end

  end

end
