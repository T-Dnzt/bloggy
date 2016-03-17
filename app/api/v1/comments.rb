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
            requires :post_id, type: String
            requires :data, type: Hash do
              requires :type, type: String
              requires :attributes, type: Hash do
                requires :author, type: String
                optional :email, type: String
                optional :website, type: String
                requires :content, type: String
              end
            end
          end
          post do
            post = Post.find(params[:post_id])
            comment = post.comments.create!(declared(params)['data']['attributes'])
            Presenters::Comment.new(base_url, comment).as_json_api
          end

          desc 'Update a comment.'
          params do
            requires :post_id, type: String
            requires :id
            requires :data, type: Hash do
              requires :type, type: String
              requires :attributes, type: Hash do
                optional :author, type: String
                optional :email, type: String
                optional :website, type: String
                optional :content, type: String
              end
            end
          end
          patch ':id' do
            post = Post.find(params[:post_id])
            comment = post.comments.find(params[:id])
            comment_params = declared(params)['data']['attributes'].reject { |k, v| v.nil? }
            comment.update_attributes!(comment_params)
            Presenters::Comment.new(base_url, comment.reload).as_json_api
          end

          desc 'Delete a comment.'
          params do
            requires :id, type: String
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
