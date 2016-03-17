# spec/models/post_spec.rb
require 'spec_helper'

describe Post do

  it 'has a valid factory' do
    expect(build(:post)).to be_valid
  end

  describe 'validations' do

    it 'is invalid without a slug' do
      expect(build(:post, slug: nil)).to_not be_valid
    end

    it 'is invalid without a title' do
      expect(build(:post, title: nil)).to_not be_valid
    end

    it 'is invalid with a duplicated slug' do
      create(:post)
      expect(build(:post)).to_not be_valid
    end

  end

end
