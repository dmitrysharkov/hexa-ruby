module Hexa
  module Pipes
    class Filter < Pipe
      def inverse
        !!@options[:inverse]
      end

      def call(pipeline, payload)
        result = super

        if result
          inverse ? Skip.new : Success.new(payload)
        else
          inverse ? Success.new(payload) : Skip.new
        end
      end
    end
  end
end
