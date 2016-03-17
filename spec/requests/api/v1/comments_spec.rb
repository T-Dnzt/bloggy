# spec/requests/api/v1/posts_spec.rb
require 'spec_helper'

describe API::V1::Comments do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  let(:url) { BASE_URL }
  let(:post_object) { create(:post) }

  # We need to define a set of correct attributes to create comments
  let(:attributes) do
    {
      author: 'Thibault',
      email: 'thibault@example.com',
      website: 'samurails.com',
      content: 'Super Comment.'
    }
  end

  # And valid_params that use the previous attributes and
  # add the JSON API spec enveloppe
  let(:valid_params) do
    {
      data: {
        type: 'comments',
        attributes: attributes
      }
    }
  end

  # We also need an invalid set of params to test
  # that Grape validates correctly
  let(:invalid_params) do
    {
      data: {}
    }
  end

  before do
    header 'Content-Type', 'application/vnd.api+json'
  end

  describe 'POST /posts/:post_id/comments' do

    # We use contexts here to separate our requests that
    # have valid parameters vs the ones that have invalid parameters
    context 'with valid attributes' do

      # Now we're using post and not get to make our requests.
      # We also pass the parameters we want
      it 'returns HTTP status 201 - Created' do
        post "/api/v1/posts/#{post_object.id}/comments", valid_params.to_json
        expect(last_response.status).to eq 201
      end

      # After the request, we check in the database that our comment
      # was persisted
      it 'creates the resource' do
        post "/api/v1/posts/#{post_object.id}/comments", valid_params.to_json
        comment = post_object.reload.comments.find(json['data']['id'])
        expect(comment).to_not eq nil
      end

      # Here we check that all the attributes were correctly assigned during
      # the creation. We could split this into different tests but I got lazy.
      it 'creates the resource with the specified attributes' do
        post "/api/v1/posts/#{post_object.id}/comments", valid_params.to_json
        comment = post_object.reload.comments.find(json['data']['id'])
        expect(comment.author).to eq attributes[:author]
        expect(comment.email).to eq attributes[:email]
        expect(comment.website).to eq attributes[:website]
        expect(comment.content).to eq attributes[:content]
      end

      # Here we check that the endpoint returns what we want, in a format
      # that follows the JSON API specification
      it 'returns the appropriate JSON document' do
        post "/api/v1/posts/#{post_object.id}/comments", valid_params.to_json
        id = post_object.reload.comments.first.id
        expect(json['data']).to eq({
          'type' => 'comments',
          'id' => id.to_s,
          'attributes' => {
            'author' => 'Thibault',
            'email' => 'thibault@example.com',
            'website' => 'samurails.com',
            'content' => 'Super Comment.'
          },
          'links' => { 'self' => "#{BASE_URL}/comments/#{id}" },
          'relationships' => {}
        })
      end

    end

    # What happens when we send invalid attributes?
    context 'with invalid attributes' do

      # Grape should catch it and return 400!
      it 'returns HTTP status 400 - Bad Request' do
        post "/api/v1/posts/#{post_object.id}/comments", invalid_params.to_json
        expect(last_response.status).to eq 400
      end

    end

  end

  # Let's try to update stuff now!
  describe 'PATCH /posts/:post_id/comments/:id' do

    # We make a comment, that's the one we will be updating
    let(:comment) { create(:comment, post: post_object) }

    # What we want to change in our comment
    let(:attributes) do
      {
        author: 'Tibo',
        content: 'My bad.'
      }
    end

    # Once again, separate valid parameters and invalid parameters
    # with contexts. The tests don't have anything new compared to
    # what we wrote for the creation tests.
    context 'with valid attributes' do

      it 'returns HTTP status 200 - OK' do
        patch "/api/v1/posts/#{post_object.id}/comments/#{comment.id}", valid_params.to_json
        expect(last_response.status).to eq 200
      end

      it 'updates the resource author and content' do
        patch "/api/v1/posts/#{post_object.id}/comments/#{comment.id}", valid_params.to_json
        expect(comment.reload.author).to eq 'Tibo'
        expect(comment.reload.content).to eq 'My bad.'
      end

      it 'returns the appropriate JSON document' do
        patch "/api/v1/posts/#{post_object.id}/comments/#{comment.id}", valid_params.to_json
        id = comment.id
        expect(json['data']).to eq({
          'type' => 'comments',
          'id' => id.to_s,
          'attributes' => {
            'author' => 'Tibo',
            'email' => 'thibault@example.com',
            'website' => 'samurails.com',
            'content' => 'My bad.'
          },
          'links' => { 'self' => "#{BASE_URL}/comments/#{id}" },
          'relationships' => {}
        })
      end

    end

    context 'with invalid attributes' do

      it 'returns HTTP status 400 - Bad Request' do
        patch "/api/v1/posts/#{post_object.id}/comments/#{comment.id}", invalid_params.to_json
        expect(last_response.status).to eq 400
      end

    end

  end

  # Let's delete stuff, yay \o/
  describe 'DELETE /posts/:post_id/comments/:id' do

    let(:comment) { create(:comment, post: post_object) }

    # The request works...
    it 'returns HTTP status 200 - Ok' do
      delete "/api/v1/posts/#{post_object.id}/comments/#{comment.id}"
      expect(last_response.status).to eq 200
    end

    # ... but did it really remove the comment from the DB?
    it 'removes the comment' do
      id = comment.id
      delete "/api/v1/posts/#{post_object.id}/comments/#{id}"
      comment = post_object.reload.comments.where(id: id).first
      expect(comment).to eq nil
    end

  end

end
