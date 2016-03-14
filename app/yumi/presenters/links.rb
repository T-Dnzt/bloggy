module Yumi
  module Presenters
    class Links

      def initialize(options)
        @options = options
        @links = @options[:links]
        @url = @options[:url]
        @plural = @options[:names][:plural]
        @resource = @options[:resource]
      end

      # Each presenter can define which links it wants.
      # For now Yumi only supports the self link but we
      # could add pagination links for example using this feature.
      def to_json_api
        @links.each_with_object({}) do |link_type, hash|
          hash[link_type] = send("#{link_type}_link")
        end
      end

      private

      def self_link
        if @resource.respond_to?(:each)
          "#{@url}/#{@plural}"
        else
          "#{@url}/#{@plural}/#{@resource.id}"
        end
      end

    end
  end
end
