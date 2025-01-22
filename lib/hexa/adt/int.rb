# frozen_string_literal: true
#
module Hexa
  module Adt
    class Int < Scalar
      self.base_class = ::Integer

      coerce ::String do |val|
        [Integer(val), true]
      rescue ArgumentError
        [nil, false]
      end

      invariant(:gt, ::Integer) { |val, base| val > base }
      invariant(:gteq, ::Integer) { |val, base| val >= base }
      invariant(:lt, ::Integer) { |val, base| val < base }
      invariant(:lteq, ::Integer) { |val, base| val <= base }
    end
  end
end
