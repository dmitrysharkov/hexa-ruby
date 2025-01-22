module Hexa
  module Pipes
    class Map < Pipe
      def call(pipeline, payload)
        result = super

        raise("#{output_type} expected") unless result.is_a?(output_type)

        Success.new(result)
      end
    end
  end
end
