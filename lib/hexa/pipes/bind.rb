module Hexa
  module Pipes
    class Bind < Pipe
      def call(pipeline, payload)
        monad = super

        raise('Monad expected') unless monad.is_a?(Monad)
        raise("#{output_type} expected") if monad.is_a?(Success) && !monad.result.is_a?(output_type)

        monad
      end
    end
  end
end
