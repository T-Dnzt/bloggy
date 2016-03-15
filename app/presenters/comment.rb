# app/presenters/comment.rb
module Presenters
  class Comment < ::Yumi::Base

    meta META_DATA
    attributes :author, :email, :website, :content
    links :self

  end

end
