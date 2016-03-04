# app/models/tag.rb
class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :slug, type: String
  field :name, type: String

  # This model should be saved in the post document
  embedded_in :post

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true

  index({ slug: 1 }, { unique: true, name: "slug_index" })
end
