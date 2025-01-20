# frozen_string_literal: true

module Hexa
  module Values
    module ScalarMixin
      module ClassMethods
        def |(other)
          Union.new(self, other)
        end

        def base_class
          @base_class
        end

        def construct(val, options = {})
          context = BuilderContext.init(options)

          if val.is_a?(Undefined)
            context.error(:missed)
          elsif !val.is_a?(base_class)
            context.error(:expected_type, base_class)
          else
            invariants.validate(val, context)
          end

          if context.errors?
            [nil, context.errors]
          else
            [val, nil]
          end
        end

        def inherited(subclass)
          super

          bc = base_class
          subclass.instance_exec { @base_class = bc }
          subclass.invariants.inherit(invariants)
        end

        def write_to_stream(val, stream)
          case val
          when ::TrueClass then stream.write_bool(val)
          when ::FalseClass then stream.write_bool(val)
          when ::String then stream.write_str(val)
          when ::Integer then stream.write_int(val)
          when ::Float then stream.write_real(val)
          when ::NilClass then stream.write_null
          else
            raise("Not implemented for #{base_class}")
          end
        end
      end

      def self.included(clazz)
        super
        clazz.extend(ClassMethods)
        clazz.extend(InvariantsMixin)
        clazz.instance_exec { @base_class = superclass }
      end
    end
  end
end
