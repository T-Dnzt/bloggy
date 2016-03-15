# app/presenters/tag.rb
module Presenters
  class Tag < ::Yumi::Base

    meta META_DATA
    attributes :slug, :name
    links :self

  end

end
