module Yumi
  module Presenters
    class Resource

      def initialize(options)
        @options = options.dup
        @resource = @options[:resource]
      end

      def to_json_api
        if @resource.respond_to?(:each)
          @resource.map { |r| data(r).to_json_api }
        else
          data(@resource).to_json_api
        end
      end

      private

      def data(resource)
        @options[:resource] = resource
        Yumi::Presenters::Data.new(@options)
      end

    end
  end
end
