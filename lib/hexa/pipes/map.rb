# frozen_string_literal: true

module Hexa
  module Pipes
    class Map < Pipe

      def proceed(monad)
        Success.new(fn.call(monad.result))
      end
    end
  end
end
