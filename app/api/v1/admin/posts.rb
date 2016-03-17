# app/api/v1/admin/posts.rb
module API
  module V1
    module Admin
      class Posts < Grape::API
        version 'v1', using: :path, vendor: 'samurails-blog'

        namespace :admin do

          helpers do
            def base_url
              "http://#{request.host}:#{request.port}/api/#{version}/admin"
            end
          end

          resources :posts do

            desc 'Returns all posts'
            get do
              Presenters::Post.new(base_url, Post.all.ordered).as_json_api
            end

            desc "Return a specific post"
            params do
              requires :id, type: String
            end
            get ':id' do
              Presenters::Post.new(base_url, Post.find(params[:id])).as_json_api
            end

            desc "Create a new post"
            params do
              requires :data, type: Hash do
                requires :type, type: String
                requires :attributes, type: Hash do
                  requires :slug, type: String
                  requires :title, type: String
                  optional :content, type: String
                end
              end
            end
            post do
              post = Post.create!(declared(params)['data']['attributes'])
              Presenters::Post.new(base_url, post).as_json_api
            end

            desc "Update a post"
            params do
              requires :id, type: String
              requires :data, type: Hash do
                requires :type, type: String
                requires :id, type: String
                requires :attributes, type: Hash do
                  optional :slug, type: String
                  optional :title, type: String
                  optional :content, type: String
                end
              end
            end
            patch ':id' do
              post = Post.find(params[:id])
              post_params = declared(params)['data']['attributes'].reject { |k, v| v.nil? }
              post.update_attributes!(post_params)
              Presenters::Post.new(base_url, post.reload).as_json_api
            end

            desc "Delete a post"
            params do
              requires :id, type: String
            end
            delete ':id' do
              Post.find(params[:id]).destroy
            end

          end
        end
      end

    end
  end
end
