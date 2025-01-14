module Hexa
  module Schema
    class Attribute
      attr_accessor :idx, :name, :name_str, :name_var, :required, :descriptor

      def initialize(idx, name, required, descriptor)
        @idx = idx
      end

      def instantiate(src, context)

      end
    end
  end
end
