# spec/models/tag_spec.rb
require 'spec_helper'

describe Tag do

  it 'has a valid factory' do
    expect(build(:tag)).to be_valid
  end

  describe 'validations' do

    it 'is invalid without a slug' do
      expect(build(:tag, slug: nil)).to_not be_valid
    end

    it 'is invalid without a name' do
      expect(build(:tag, name: nil)).to_not be_valid
    end

    it 'is invalid with a duplicated slug in the same post' do
      post = build(:post)
      create(:tag, post: post)
      expect(build(:tag, post: post)).to_not be_valid
    end

  end

end
