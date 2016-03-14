# app/yumi/presenters/attributes.rb
module Yumi
  module Presenters
    class Attributes

      def initialize(options)
        @options = options
        @attributes = @options[:attributes]
        @presenter = @options[:presenter]
        @resource = @options[:resource]
      end

      # Takes the given list of attributes, loops through
      # them and get the corresponding value from the presenter
      # or the resource
      def to_json_api
        @attributes.each_with_object({}) do |attr, hash|
          hash[attr] = (@presenter.respond_to?(attr) ? @presenter : @resource).send(attr)
        end
      end

    end
  end
end
