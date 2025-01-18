module Hexa
  module Values
    class Attribute
      attr_reader :name, :setter, :private_getter, :type, :defined_predicate_name, :description

      def initialize(name, type, desc)
        @description = desc
        @name = name.to_sym
        @setter = :"#{name}="
        @type = type
        @defined_predicate_name = :"#{name}_defined?"
        @private_getter = :"_#{name}"
      end
    end
  end
end
