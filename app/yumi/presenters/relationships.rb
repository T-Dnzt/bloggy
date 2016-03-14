module Yumi
  module Presenters
    class Relationships

      def initialize(options)
        @options = options
        @url = @options[:url]
        @plural = @options[:names][:plural]
        @resource = @options[:resource]
        @relationships = @options[:relationships]
      end

      def to_json_api
        @relationships.each_with_object({}) do |rel, hash|
          hash[rel] = presenter(rel).new(@url,
                                         @resource.send(rel),
                                         prefix).as_relationship
        end
      end

      private

      def prefix
        @prefix ||= "#{@plural}/#{@resource.id}/"
      end

      def presenter(rel)
        "Presenters::#{rel.to_s.singularize.capitalize}".constantize
      end

    end
  end
end
