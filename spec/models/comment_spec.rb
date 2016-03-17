# spec/models/comment_spec.rb
require 'spec_helper'

describe Comment do

  it 'has a valid factory' do
    expect(build(:comment)).to be_valid
  end

  describe 'validations' do

    it 'is invalid without an author' do
      expect(build(:comment, author: nil)).to_not be_valid
    end

    it 'is invalid without a content' do
      expect(build(:comment, content: nil)).to_not be_valid
    end

  end

end
