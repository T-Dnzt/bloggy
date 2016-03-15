# app/api/v1/posts.rb
module API
  module V1
    class Posts < Grape::API
      version 'v1', using: :path, vendor: 'samurails-blog'

      resources :posts do

        desc 'Returns all posts'
        get '/' do
          Presenters::Post.new(base_url, Post.all.ordered).as_json_api
        end

        desc "Return a specific post"
        params do
          requires :id, type: String
        end
        get ':id' do
          Presenters::Post.new(base_url, Post.find(params[:id])).as_json_api
        end

      end
    end
  end
end
