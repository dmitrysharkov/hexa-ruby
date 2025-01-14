module Hexa
  module Schema
    class Struct
      attr_reader :attributes, :struct_class

      def initialize
        @attributes = []
      end

      def freeze
        @struct_class = ::Struct.new(*attributes.map(&:name))
        super
      end

      def instantiate(src, context)
        context.errors << [:expected, :object] if src.is_a?(Hash)

        if block_given?
          attributes.each do |attr|
            yield attr, attr.instantiate(src, context)
          end
        else
          struct_class.new(*attributes.map { |attr| attr.instantiate(src, context) } )
        end
      end

      def inject(dst, *args, **kw_args)
        errors = []

        src = args_to_source(*args, **kw_args)

        instantiate(src, errors) do |attr, val|
          dst.instance_variable_set(attr.name_var, val)
        end

        raise ArgumentError, errors.to_s, caller[1..-1] if errors.any?
      end

      private

      ARGS_ERROR = "expected hash as first param, or kwargs, or ".freeze

      def args_to_source(*args, **kw_args)
        raise(ArgumentError, ARGS_ERROR, caller[2..-1]) if args.none? && kw_args.none?
        raise(ArgumentError, ARGS_ERROR, caller[2..-1]) if args.any? && kw_args.any?

        return kw_args if args.none?

        return args.map.with_index { |val, idx| [attributes[idx].name, val] }.to_h if args.size > 1


        if attributes.size == 1
          return { attributes.first.name => args[0] } if attributes.descriptor
        else
          return args[0] if args[0].is_a?(Hash)
          raise ArgumentError, ARGS_ERROR, caller[2..-1]
        end
      end
    end
  end
end
