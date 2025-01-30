module Hexa
  module Container
    module Dsl
      def type(clazz, &block)
        Class.new(clazz) do
          extend Type unless clazz.is_a?(Type)
          include Value unless clazz < Value

          prototype!(&block)
        end
      end

      def int
        Int
      end

      def str
        Str
      end

      def bool
        Bool
      end

      def real
        Real
      end

      def key(key, type)
        type[key]
      end
    end
  end
end

