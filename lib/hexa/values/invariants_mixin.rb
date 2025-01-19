module Hexa
  module Values
    module InvariantsMixin
      def invariants
        @invariants ||= Invariants.new
      end

      def invariant(name, *types, &block)
        invariants.add_invariant(name, types, &block)
      end

      def validate(*args, **kw_args, &block)
        invariants.add_validators(caller, args, kw_args, block)
      end
    end
  end
end
