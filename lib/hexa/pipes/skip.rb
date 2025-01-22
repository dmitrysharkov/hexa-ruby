# frozen_string_literal: true

module Hexa
  module Pipes
    class Skip < Monad
      def ==(other)
        other.is_a?(self.class)
      end
    end
  end
end
