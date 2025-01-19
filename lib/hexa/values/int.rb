# frozen_string_literal: true
#
module Hexa
  module Values
    class Int < ::Integer
      include ScalarMixin

      invariant(:gt, ::Integer) { |val, base| val > base }
      invariant(:gteq, ::Integer) { |val, base| val >= base }
      invariant(:lt, ::Integer) { |val, base| val > base }
      invariant(:lteq, ::Integer) { |val, base| val >= base }
    end
  end
end
