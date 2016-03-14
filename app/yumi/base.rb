# app/yumi/base.rb
require_relative 'class_methods'

module Yumi
  class Base
    extend Yumi::ClassMethods

    # Initialize a presenter
    # url: The current API/version path.
    # Example: http://example.com/api/v1
    #
    # resource: The resource to present. It can be a main resource, a related
    # resource or an included resource. Can take in list of resources or
    # unique resource.
    #
    # prefix: Used for relationships. Will prefix the related resource link
    # Example: /posts/xxx
    #
    def initialize(url, resource, prefix = nil)
      name = self.class.name
      @options = {
        presenter: self,
        url: url,
        resource: resource,
        prefix: prefix,
        names: {
          demodulized: name.demodulize,
          singular: name.demodulize.downcase,
          plural: name.demodulize.downcase.pluralize
        }
      }
      set_instance_variables
    end

    # Generates the default resource JSON API hash
    def as_json_api
      {
        meta: @options[:meta],
        data: Yumi::Presenters::Resource.new(@options).to_json_api,
        links: Yumi::Presenters::Links.new(@options).to_json_api,
        included: Yumi::Presenters::IncludedResources.new(@options).to_json_api
      }
    end

    # Used inside the Resource presenter to build
    # the JSON API hash for relationship
    def as_relationship
      {
        data: @options[:resource].map { |c| { type: @options[:names][:plural], id: c.id.to_s } },
        links: {
          self: "#{@options[:url]}/#{@options[:prefix]}relationships/#{@options[:names][:plural]}",
          related: "#{@options[:url]}/#{@options[:prefix]}#{@options[:names][:plural]}"
        }
      }
    end

    # Used inside the IncludedResources presenter to build
    # the JSON API hash for included resources
    def as_included
      {
        type: @options[:names][:plural],
        id: @options[:resource].id.to_s,
        attributes: Yumi::Presenters::Attributes.new(@options).to_json_api,
        links: Yumi::Presenters::Links.new(@options).to_json_api
      }
    end

    private

    # Assigns the class variables to the instance
    def set_instance_variables
      @options[:meta] = self.class.send("_meta") || {}

      [:relationships, :links, :attributes].each do |v|
        @options[v] = self.class.send("_#{v}") || []
      end
    end

  end
end
