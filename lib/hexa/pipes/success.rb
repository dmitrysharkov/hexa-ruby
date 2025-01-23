# frozen_string_literal: true

module Hexa
  module Pipes
    class Success < Monad
      attr_reader :result
      def self.[](result)
        new(result)
      end

      def initialize(result)
        super()
        @result = result
      end

      def ==(other)
        other.is_a?(self.class) && other.result == result
      end
    end
  end
end
