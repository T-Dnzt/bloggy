module Yumi
  module Presenters
    class IncludedResources

      def initialize(options)
        @options = options
        @url = options[:url]
        @resource = options[:resource]
        @relationships = @options[:relationships]
        @included_resources = {}
      end

      # Loads the included resources
      def to_json_api
        if @resource.respond_to?(:each)
          @resource.each { |r| included_data(r, @included_resources) }
        else
          included_data(@resource, @included_resources)
        end
        @included_resources.values
      end

      private

      # We only want to include each related resource once
      # so we use a hash to avoid duplicates
      def included_data(resource, hash)
        @relationships.each do |rel|
          resource.send(rel).each do |associated_resource|
            key = "#{rel}:#{associated_resource.id}"

            unless hash[key]
              hash[key] = presenter(rel).new(@url, associated_resource).as_included
            end
          end
        end
      end

      def presenter(rel)
        "Presenters::#{rel.to_s.singularize.capitalize}".constantize
      end

    end
  end
end
