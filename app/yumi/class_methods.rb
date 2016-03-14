# app/yumi/class_methods.rb
module Yumi
  module ClassMethods

    # Define some getters to access from our future instances
    attr_reader :_relationships, :_links, :_attributes, :_meta

    # Methods to set the options from a presenter class
    def meta(meta_data)
      @_meta = meta_data
    end

    def attributes(*args)
      @_attributes = args
    end

    def has_many(*args)
      @_relationships = args
    end

    def links(*args)
      @_links = args
    end

  end
end
