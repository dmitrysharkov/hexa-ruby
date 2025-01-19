# frozen_string_literal: true

module Hexa
  module Values
    class Union
      def initialize(*args)
        @types = args
      end

      def |(other)
        self.class.new(*(to_a + [other]))
      end

      def deconstruct
        @types
      end

      def to_a
        deconstruct
      end

      def include?(type)
        @types.include?(type)
      end

      def construct(src, options = {})
        context = BuilderContext.init(options)

        @types.each do |type|
          local_context = BuilderContext.new(context.options.reject { |key| key == :raise_at })
          val, err = type.construct(src, local_context)

          next if err

          return [val, nil]
        end

        context.error(:format)
        [nil, context.errors]
      end
    end
  end
end
