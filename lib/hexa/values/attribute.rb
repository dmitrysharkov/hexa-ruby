# frozen_string_literal: true

module Hexa
  module Values
    class Attribute
      attr_reader :name, :setter, :private_getter, :type, :description

      def initialize(name, type, desc)
        @description = desc
        @name = name.to_sym
        @setter = :"#{name}="
        @type = type
        @defined_predicate_name =
        @private_getter = :"_#{name}"
      end

      def defined_predicate_name
        :"#{name}_defined?"
      end
    end
  end
end
