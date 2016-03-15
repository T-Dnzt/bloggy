# app/presenters/post.rb
module Presenters
  class Post < ::Yumi::Base

    meta META_DATA
    attributes :slug, :title, :content
    has_many :tags, :comments
    links :self

  end
end
