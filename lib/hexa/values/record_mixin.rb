# frozen_string_literal: true

module Hexa
  module Values
    module RecordMixin
      # Record class methods
      module ClassMethods
        def attributes
          @attributes ||= []
        end


        def attr_annotate(name, type, desc: nil)
          attr = Attribute.new(name.to_sym, type, desc)

          @builder = nil
          attributes << attr

          attr_writer attr.name
          private attr.setter

          if type.is_a?(Union) && type.include?(Undefined)
            alias_method attr.private_getter, attr.name
            private attr.private_getter

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
          @builder ||= RecordBuilder.new(self)
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
          when :Str then Values::Str
          when :Bool then Values::Bool
          when :Int then Values::Int
          when :Real then Values::Real
          when :List then Values::List
          when :Dt then Values::Dt
          when :Null then Null
          when :Undefined then Values::Undefined
          when :Values, :V, :Val then Values
          else
            raise TypeError
          end
        end

        def inherited(subclass)
          super
          attributes.each { |attr| subclass.attributes << attr }
          subclass.invariants.inherit(invariants)
        end

        def [](**validators)
          Class.new(self) do
            validators.each do |predicate, params|
              if params.is_a?(TrueClass)
                validate(predicate)
              else
                validate(predicate, *params)
              end
            end
          end
        end
      end

      def self.included(clazz)
        clazz.extend(ClassMethods)
        clazz.extend(InvariantsMixin)
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

      def ==(other)
        return false unless other.is_a?(self.class)

        self.class.attributes.each do |attr|
          return false unless send(attr.private_getter) == other.send(attr.private_getter)
        end
      end

      def attribute_defined?(name)
        send("#{name}_defined?")
      end

      def attribute_value(name)
        send(name)
      end
    end
  end
end
