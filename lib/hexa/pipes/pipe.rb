module Hexa
  module Pipes
    class Pipe
      attr_reader :fn, :output_type, :options

      def initialize(subject, out:, **options, &block)
        @output_type = out
        @options = options
        @fn = block_given? ? block : proc { |argument| send(subject, argument) }
      end

      def call(pipeline, payload)
        pipeline.instance_exec(payload, &fn)
      end
    end
  end
end
