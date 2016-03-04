# app/models/post.rb
class Post
  # We define this class as a Mongoid Document
  include Mongoid::Document

  # Generates created_at and updated_at
  include Mongoid::Timestamps

  # Defining our fields with their types
  field :slug, type: String
  field :title, type: String
  field :content, type: String

  # tags and comments will be stored inside the
  # Post document
  embeds_many :tags
  embeds_many :comments

  # Sort the posts
  scope :ordered, -> { order('created_at DESC') }

  # Validates that the slug is present and unique
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true

  # The slug has to be unique since it can be used to query post.
  # Also defining an index will make the query more efficient
  index({ slug: 1 }, { unique: true, name: "slug_index" })
end
