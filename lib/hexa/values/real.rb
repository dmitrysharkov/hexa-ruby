# frozen_string_literal: true

module Hexa
  module Values
    class Real < ::Float
      include ScalarMixin

      invariant(:gt, ::Numeric) { |val, base| val > base }
      invariant(:gteq, ::Numeric) { |val, base| val >= base }
      invariant(:lt, ::Numeric) { |val, base| val > base }
      invariant(:lteq, ::Numeric) { |val, base| val >= base }
    end
  end
end
