# frozen_string_literal: true

module Hexa
  module Pipes
    class Tee < Pipe
      def proceed(monad)
        fn.call(monad.result)
        monad
      end
    end
  end
end
