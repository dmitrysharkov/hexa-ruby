# frozen_string_literal: true

module Hexa
  module Pipes
    class Failure < Monad
      attr_reader :error

      def self.[](error)
        new(error)
      end

      def initialize(error)
        super()
        @error = error
      end

      def ==(other)
        other.is_a?(self.class) && other.error == error
      end
    end
  end
end
