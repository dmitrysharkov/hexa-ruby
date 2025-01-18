# frozen_string_literal: true

module Hexa
  module Values
    module ObjectMixin
      # Record class methods
      module ClassMethods
        def attributes
          @attributes ||= []
        end

        def attr(name, type)
          attr = Attribute.new(name.to_sym, type)

          @builder = nil
          attributes << attr

          attr_accessor attr.name
          alias_method attr.private_getter, attr.name
          private attr.setter, attr.private_getter


          if type.is_a?(Union) && type.include?(Undefined)
            define_method(attr.name) do
              val = send(attr.private_getter)

              raise(NameError, "#{attr.name} undefined", caller[1..]) if val.is_a?(Undefined)

              val
            end
            define_method(attr.defined_predicate_name) { !send(attr.private_getter).is_a?(Undefined) }
          else
            define_method(attr.defined_predicate_name) { true }
          end
        end

        def builder
          @builder ||= ObjectBuilder.new(attributes)
        end

        def construct(source, options = {})
          return [source, nil] if source.is_a?(self)

          instance = allocate

          context = BuilderContext.init(options)
          builder.call(instance, source, context)

          [instance, context.errors]
        end

        def construct!(source, options = {})
          construct(source, options.merge(raise_at: caller[1..]))
        end

        # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
        def const_missing(name)
          case name
          when :Str then Values::String
          when :Bool then Values::Boolean
          when :Int then Values::Integer
          when :Flt then Values::Float
          when :Arr then Values::Array
          when :Null then Null
          when :Undefined then Values::Undefined
          when :Values, :V, :Val then Values
          else
            raise TypeError
          end
        end
      end

      def self.included(clazz)
        clazz.extend(ClassMethods)
      end

      def initialize(*args, **kw_args)
        source = kw_args.empty? ? args : kw_args
        context = BuilderContext.new({ raise_at: caller[1..] })
        self.class.builder.call(self, source, context)
      end

      def deconstruct
        self.class.attributes.map { |attr| public_send(attr.name) }
      end

      def deconstruct_keys(keys)
        self.class.attributes
            .select { |attr| keys.include?(attr.name) }
            .map { |attr| [attr.name, public_send(attr.name)] }
            .to_h
      end
    end
  end
end
