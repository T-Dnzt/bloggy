# spec/requests/api/v1/posts_spec.rb
require 'spec_helper'

describe API::V1::Posts do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  # Define a few let variables to use in our tests
  let(:url) { 'http://example.org:80/api/v1' }
  # We need to create a post because it needs to be in the database
  # to allow the controller to access it
  let(:post_object) { create(:post) }

  before do
    header 'Content-Type', 'application/vnd.api+json'
  end

  # Tests for the endpoint /api/v1/posts
  describe 'get /' do

    it 'returns HTTP status 200' do
      get '/api/v1/posts'
      expect(last_response.status).to eq 200
    end

    # In this describe, we split the testing of each part
    # of the JSON document. Like this, if one fails we'll know which part
    # is not working properly
    describe 'top level' do

      before do
        post_object
        get '/api/v1/posts'
      end

      it 'contains the meta object' do
        expect(json['meta']).to eq({
          'name' => 'Bloggy',
          'description' => 'A simple blogging API built with Grape.'
        })
      end

      it 'contains the self link' do
        expect(json['links']).to eq({
          'self' => "#{url}/posts"
        })
      end

      # I got lazy and didn't put the whole JSON document I'm expected,
      # instead I used the presenter to generate it.
      # It's not the best way to do this obviously.
      it 'contains the data object' do
        expect(json['data']).to eq(
          [to_json(Presenters::Post.new(url, post_object).as_json_api[:data])]
        )
      end

      it 'contains the included object' do
        expect(json['included']).to eq([])
      end

    end

    # I want to test the relationships separately
    # because they require more setup and deserve their own tests
    describe 'relationships' do

      # We need to create some related models first
      let(:tag) { create(:tag, post: post_object) }
      let(:comment) { create(:comment, post: post_object) }

      # To avoid duplicated hash, I just use a method
      # that takes a few parameters and build the hash we want
      # Could probably use shared examples instead of this but I find
      # it easier to understand
      def relationship(url, type, post_id, id)
        {
          "data" => [{"type"=> type , "id"=> id }],
          "links"=> {
            "self" => "#{url}/posts/#{post_id}/relationships/#{type}",
            "related" => "#{url}/posts/#{post_id}/#{type}"
          }
        }
      end

      # We need to call our let variables to define them
      # before the controller uses the presenter to generate
      # the JSON document
      before do
        tag
        comment
        get '/api/v1/posts'
      end

      # The following tests check that the relationships are correct
      # and that the included array is equal to the number of related
      # objects we created
      it 'contains the tag relationship' do
        id = tag.id.to_s
        expect(json['data'][0]['relationships']['tags']).to eq(
          relationship(url, 'tags', post_object.id, id)
        )
      end

      it 'contains the comment relationship' do
        id = comment.id.to_s
        expect(json['data'][0]['relationships']['comments']).to eq(
          relationship(url, 'comments', post_object.id, id)
        )
      end

      it 'includes the tag and comment in the included array' do
        expect(json['included'].count).to eq(2)
      end

    end

  end

  # Tests for the endpoint /api/v1/posts/1234567890
  describe 'get /:id' do

    # The post object is created before the request
    # since we use it to build the url
    before do
      get "/api/v1/posts/#{post_object.id}"
    end

    it 'returns HTTP status 200' do
      expect(last_response.status).to eq 200
    end

    # Repeat the same kind of tests than we defined for
    # the index route. Could totally be in shared examples
    # but that will be for another jutsu
    describe 'top level' do

      it 'contains the meta object' do
        expect(json['meta']).to eq({
          'name' => 'Bloggy',
          'description' => 'A simple blogging API built with Grape.'
        })
      end

      it 'contains the self link' do
        expect(json['links']).to eq({
          'self' => "#{url}/posts/#{post_object.id}"
        })
      end

      it 'contains the data object' do
        expect(json['data']).to eq(to_json(Presenters::Post.new(url, post_object).as_json_api[:data]))
      end

      it 'contains the included object' do
        expect(json['included']).to eq([])
      end

    end

    describe 'relationships' do

      let(:tag) { create(:tag, post: post_object) }
      let(:comment) { create(:comment, post: post_object) }

      def relationship(url, type, post_id, id)
        {
          "data" => [{"type"=> type , "id"=> id }],
          "links"=> {
            "self" => "#{url}/posts/#{post_id}/relationships/#{type}",
            "related" => "#{url}/posts/#{post_id}/#{type}"
          }
        }
      end

      before do
        tag
        comment
        get '/api/v1/posts'
      end

      it 'contains the tag relationship' do
        id = tag.id.to_s
        expect(json['data'][0]['relationships']['tags']).to eq(
          relationship(url, 'tags', post_object.id, id)
        )
      end

      it 'contains the comment relationship' do
        id = comment.id.to_s
        expect(json['data'][0]['relationships']['comments']).to eq(
          relationship(url, 'comments', post_object.id, id)
        )
      end

      it 'includes the tag and comment in the included array' do
        expect(json['included'].count).to eq(2)
      end

    end

  end

end
