module Hexa
  module Pipes
    class Pipeline
      class << self
        attr_reader :input_type, :output_type

        def payload(input_type, output_type = nil)
          @input_type = input_type
          @output_type = output_type || input_type
        end

        def pipes
          @pipes ||= []
        end

        def pipe(pipe_class, method_name = nil, out: nil, **options, &block)
          last_pipe_output_type = pipes.empty? ? output_type : pipes.last.output_type
          pipes << pipe_class.new(method_name, out: out || last_pipe_output_type, **options, &block)
        end

        def bind(method_name = nil, out: nil, &block)
          pipe(Bind, method_name, out: out, &block)
        end

        def map(method_name = nil, out: nil, &block)
          pipe(Map, method_name, out: out, &block)
        end

        def select(method_name = nil, out: nil, &block)
          pipe(Filter, method_name, out: out, &block)
        end

        def reject(method_name = nil, out: nil, &block)
          pipe(Filter, method_name, out: out, inverse: true, &block)
        end

        def const_missing(name)
          case name
          when :Success then Success
          when :Failure then Failure
          when :Skip then Skip
          end
        end
      end

      def call(payload)
        inp = payload.is_a?(Monad) ? payload : Success.new(payload)
        raise("#{self.class.input_type} expected") if inp.is_a?(Success) && !inp.result.is_a?(self.class.input_type)

        out = perform(inp)

        return out unless out.is_a?(Success)

        raise("#{self.class.output_type} expected") unless out.result.is_a?(self.class.output_type)

        out
      end
    end
  end
end
