# frozen_string_literal: true

module Hexa
  module Pipes
    class Filter < Pipe
      attr_reader :inverse
      def initialize(inverse: false, **kw_args, &block)
        super(**kw_args, &block)
        @inverse = inverse
      end

      def proceed(success)
        flag = fn.call(success.result)
        if flag
          inverse ? Skip.new : success
        else
          inverse ? success : Skip.new
        end
      end
    end
  end
end
