# frozen_string_literal: true

module Hexa
  module Pipes
    class Return < Pipe

      def proceed(monad)
        val, err = fn.call(monad.result)
        err ? Failure.new(err) : Success.new(val)
      end
    end
  end
end
