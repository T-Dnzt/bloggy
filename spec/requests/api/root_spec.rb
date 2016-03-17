# spec/requests/api/root_spec.rb
require 'spec_helper'

# Specify which class we want to test
describe API::Root do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  # required app method for Rack-Test
  def app
    OUTER_APP
  end

  # We are going to specifically test the /status
  # endpoint so we use describe here
  describe 'GET /status' do

    # We define contexts depending on the media type
    # in this case, we will use the media type application/json
    context 'media-type: application/json' do

      # This will be called every time before each following test
      before do
        # Set the header to application/json
        header 'Content-Type', 'application/json'
        # Make the actual request to /api/status using GET
        get '/api/status'
      end

      # Define our first test. Since we're using a media type
      # not supported, we expect 415
      it 'returns HTTP status 415' do
        expect(last_response.status).to eq 415
      end

      # The endpoint should also returns a JSON document
      # containing the error 'Unsupported media type'
      it 'returns Unsupported media type' do
        expect(JSON.parse(last_response.body)).to eq(
          {"error"=>"Unsupported media type"})
      end

    end

    # For this context, we use the correct media type
    context 'media-type: application/vnd.api+json' do

      # We use a different approach here. See below for explanation.
      # Basically we have our two asserts in the same test
      # I kinda prefer the first approach but wanted to show you both
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/vnd.api+json'
        get '/api/status'
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body)).to eq(
          { 'status' => 'ok' })
      end

    end

  end

end
