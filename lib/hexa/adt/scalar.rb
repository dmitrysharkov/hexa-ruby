# frozen_string_literal: true

module Hexa
  module Adt
    class Scalar
      class << self
        def |(other)
          Union.new(self, other)
        end

        def base_class
          @base_class
        end

        def base_class=(base_class)
          @base_class = base_class
        end

        def coercers
          @coercers ||= {}
        end

        def coerce(clazz, &block)
          coercers[clazz] = block
        end

        def construct(val, options = {})
          context = BuilderContext.init(options)

          if val.is_a?(Undefined)
            context.error(:missed)
            [nil, context.errors]
          end

          coerced_val, coerced = coerce_value(val)


          if coerced
            invariants.validate(coerced_val, context)
          else
            context.error(:expected_type, [base_class] + coercers.keys)
          end


          if context.errors?
            [nil, context.errors]
          else
            [coerced_val, nil]
          end
        end

        def coerce_value(val)
          return [val, true] if val.is_a?(base_class)

          coercer = coercers.detect { |clazz, _fn| val.is_a?(clazz) }
          return [nil, false] unless coercer

          coercer[1].call(val)
        end

        def inherited(subclass)
          super

          subclass.base_class = base_class
          subclass.invariants.inherit(invariants)
          coercers.each { |k, v| subclass.coercers[k] = v }

          subclass.serialize_as(serialization_class, &serializer) if serializer
        end

        def serialize_as(clazz, &block)
          @serialization_class = clazz
          @serializer = block
        end

        def serializer
          @serializer
        end

        def serialization_class
          @serialization_class
        end

        def serialize_value(val)
          serializer ? serializer.call(val) : val
        end

        def [](**validators)
          Class.new(self) do
            validators.each do |predicate, params|
              if params.is_a?(::TrueClass)
                validate(predicate)
              else
                validate(predicate, *params)
              end
            end
          end
        end

        include InvariantsMixin
      end
    end
  end
end
