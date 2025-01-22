# frozen_string_literal: true

module Hexa
  module Pipes
    class Monad
      def self.to_proc
        proc { |val| val.is_a?(self) }
      end
    end
  end
end
