module Hexa
  module Schema
    class Dsl
      def initialize(struct)
        @struct = struct
      end

      def attr(name, type, &block)
        add_attribute(name, true, type, &block)
      end

      def attr?(name, type, &block)
        add_attribute(name, false, type, &block)
      end

      private

      def add_attribute(name, required, type, &block)

      end
    end
  end
end
