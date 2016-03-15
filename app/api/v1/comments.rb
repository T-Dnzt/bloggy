# app/api/v1/comments.rb
module API
  module V1
    class Comments < Grape::API
      version 'v1', using: :path, vendor: 'samurails-blog'

      # Nested resource so we need to add the post namespace
      namespace 'posts/:post_id' do
        resources :comments do

          desc 'Create a comment.'
          params do
            requires :author, type: String
            requires :email, type: String
            requires :website, type: String
            requires :content, type: String
          end
          post do
            post = Post.find(params[:post_id])
            comment = post.comments.create!({
              author: params[:author],
              email: params[:email],
              website: params[:website],
              content: params[:content]
            })
            Presenters::Comment.new(base_url, comment).as_json_api
          end

          desc 'Update a comment.'
          params do
            requires :id, type: String
            requires :author, type: String
            requires :email, type: String
            requires :website, type: String
            requires :content, type: String
          end
          put ':id' do
            post = Post.find(params[:post_id])
            comment = post.comments.find(params[:id])

            comment.update!({
              author:  params[:author],
              email:   params[:email],
              website: params[:website],
              content: params[:content]
            })

            Presenters::Comment.new(base_url, comment.reload).as_json_api
          end

          desc 'Delete a comment.'
          params do
            requires :id, type: String, desc: 'Status ID.'
          end
          delete ':id' do
            post = Post.find(params[:post_id])
            post.comments.find(params[:id]).destroy
          end

        end
      end

    end
  end
end
