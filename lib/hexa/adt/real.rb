# frozen_string_literal: true

module Hexa
  module Adt
    class Real < Scalar
      self.base_class = ::Float

      coerce ::String do |val|
        [Float(val), true]
      rescue ArgumentError
        [nil, false]
      end

      coerce ::Integer, &:to_f

      invariant(:gt, ::Numeric) { |val, base| val > base }
      invariant(:gteq, ::Numeric) { |val, base| val >= base }
      invariant(:lt, ::Numeric) { |val, base| val < base }
      invariant(:lteq, ::Numeric) { |val, base| val <= base }
    end
  end
end
