# frozen_string_literal: true

module Hexa
  module Values
    class Attribute
      attr_reader :name, :setter, :private_getter, :type, :description, :defined_predicate_name, :camelized_name_str

      def initialize(name, type, desc)
        @description = desc
        @name = name.to_sym
        @setter = :"#{name}="
        @type = type
        @private_getter = :"_#{name}"
        @defined_predicate_name = :"#{name}_defined?"
        @camelized_name_str = name.to_s.split('_').map.with_index { |part, idx| idx > 0 ? part.capitalize : part }.join
      end
    end
  end
end
