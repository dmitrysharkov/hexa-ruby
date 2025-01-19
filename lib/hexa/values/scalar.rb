# frozen_string_literal: true

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

          if val.is_a?(Undefined)
            context.error(:missed)
          elsif !val.is_a?(base_class)
            context.error(:expected_type, base_class)
          else
            invariants.each do |name, attributes, fn|
              context.error(name, *attributes) unless fn.call(val, *attributes)
            end
          end

          if context.errors?
            [nil, context.errors]
          else
            [val, nil]
          end
        end

        def invariants
          @invariants ||= []
        end

        INVARIANTS = {
          gt: proc { |val, base| val > base },
          gteq: proc { |val, base| val >= base },
          lt: proc { |val, base| val < base },
          lteq: proc { |val, base| val <= base },
          format: proc { |val, re| re =~ val }
        }.freeze

        def validate(name, *args, &block)
          invariants << [name, args, block ? proc(&block) : INVARIANTS[name]]
        end

        def inherited(subclass)
          super

          subclass.base_class = base_class
          invariants.each { |inv| subclass.invariants << inv }
        end
      end

      def self.included(clazz)
        clazz.extend(ClassMethods)
        clazz.base_class = clazz.superclass
      end
    end
  end
end
