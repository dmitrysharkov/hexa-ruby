# frozen_string_literal: true

module Hexa
  module Pipes
    class Bind < Pipe
      def proceed(monad)
        fn.call(monad.result)
      end
    end
  end
end
