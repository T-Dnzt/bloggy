# spec/factories.rb
FactoryGirl.define do
  factory :post do
    slug 'my-slug'
    title 'My Title'
    content 'Some Random Content.'
  end

  factory :comment do
    author 'Thibault Denizet'
    email 'thibault@example.com'
    website 'samurails.com'
    content 'This post is cool!'
    association :post, factory: :post
  end

  factory :tag do
    slug 'ruby-on-rails'
    name 'Ruby on Rails'
    association :post, factory: :post
  end

end
