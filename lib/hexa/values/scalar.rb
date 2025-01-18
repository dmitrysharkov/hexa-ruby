module Hexa
  module Values
    module Scalar
      module ClassMethods
        def |(other)
          Union.new(self, other)
        end

        def base_class
          @base_class
        end

        def base_class=(clazz)
          @base_class = clazz
        end

        def construct(val, options = {})
          context = BuilderContext.init(options)

          context.error(:missed) if val.is_a?(Undefined)
          context.error(:format) unless val.is_a?(base_class)

          if context.errors?
            [nil, context.errors]
          else
            [val, nil]
          end
        end
      end

      def self.included(clazz)
        clazz.extend(ClassMethods)
        clazz.base_class = clazz.superclass
      end
    end
  end
end
