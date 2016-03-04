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
            post.comments.create!({
              author: params[:author],
              email: params[:email],
              website: params[:website],
              content: params[:content]
            })
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
            post.comments.find(params[:id]).update!({
              author: params[:author],
              email: params[:email],
              website: params[:website],
              content: params[:content]
            })
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
