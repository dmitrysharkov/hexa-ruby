module Hexa
  module Values
    class Invariants
      Validator = Struct.new(:name, :params, :fn, :require_options)
      Predicate = Struct.new(:name, :types, :fn)

      attr_reader :predicates, :validators

      def initialize
        @predicates = {}
        @validators = []
      end

      def add_invariant(name, types, &block)
        predicate = Predicate.new(name, types, block)
        predicates[predicate.name] = predicate
      end

      def inherit(other, with_validators: true)
        raise(ArgumentError, "#{Invariants} expected", caller[1..]) unless other.is_a?(Invariants)

        @predicates = other.predicates.clone
        @validators = other.validators.clone if with_validators

        self
      end

      def add_validators(call_stack, args, kw_args, predicate)
        add_validator(args.first, args[1..], call_stack, predicate) unless args.empty?
        kw_args.each { |name, params| add_validator(name, params, call_stack, nil) }
      end

      def validate(val, context)
        validators.each { |v| apply_validator(v, val, context) }
      end

      private

      def apply_validator(validator, val, context)
        context.error(validator.name, *validator.params) unless apply_predicate(validator, val)
      end

      def apply_predicate(validator, val)
        if validator.require_options
          validator.fn.call(val, *validator.params, options: context.options)
        else
          validator.fn.call(val, *validator.params)
        end
      end

      def add_validator(name, params, call_stack, func)
        fn = func || prepare_fn(name, params, call_stack)
        params = [params] unless params.is_a?(Array)

        require_options = fn.parameters.last == %i[keyreq options]

        validators << Validator.new(name, params, fn, require_options)
      end

      def prepare_fn(name, params, call_stack)
        predicate = predicates[name]

        raise(ArgumentError, "Unknown predicate #{name}", call_stack) unless predicate

        predicate.types.each.with_index do |type, idx|
          next if params[idx].is_a?(type)

          raise(ArgumentError, "#{type} expected as parameter #{idx} of the #{name} validator", call_stack)
        end

        predicate.fn
      end
    end
  end
end
