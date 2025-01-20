# frozen_string_literal: true

module Hexa
  module Values
    class Bool < Scalar
      self.base_class = TrueClass

      TRUE_STRINGS = %w[ture yes].freeze
      FALSE_STRINGS = %w[false no].freeze

      coerce String do |val|
        val = val.downcase

        if TRUE_STRINGS.include?(val)
          [true, true]
        elsif FALSE_STRINGS.include?(val)
          [false, true]
        else
          [nil, false]
        end
      end

      coerce Integer do |val|
        case val
        when 0 then [false, true]
        when 1 then [true, true]
        else [nil, false]
        end
      end
    end
  end
end
