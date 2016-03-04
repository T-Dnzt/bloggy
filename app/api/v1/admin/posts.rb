# app/api/v1/admin/posts.rb
module API
  module V1
    module Admin
      class Posts < Grape::API
        version 'v1', using: :path, vendor: 'samurails-blog'

        namespace :admin do

          resources :posts do

            desc 'Returns all posts'
            get do
              Post.all.ordered
            end

            desc "Return a specific post"
            params do
              requires :id, type: String
            end
            get ':id' do
              Post.find(params[:id])
            end

            desc "Create a new post"
            params do
              requires :slug, type: String
              requires :title, type: String
              requires :content, type: String
            end
            post do
              Post.create!(slug: params[:slug],
                                   title: params[:title],
                                   content: params[:content])
            end

            desc "Update a post"
            params do
              requires :id, type: String
              requires :slug, type: String
              requires :title, type: String
              requires :content, type: String
            end
            put ':id' do
              post = Post.find(params[:id])
              post.update(slug: params[:slug],
                          title: params[:title],
                          content: params[:content])
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
