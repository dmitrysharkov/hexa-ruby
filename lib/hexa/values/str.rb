# frozen_string_literal: true

module Hexa
  module Values
    class Str < Scalar
      self.base_class = ::String

      invariant(:pattern, ::Regexp) { |val, re| re =~ val }
      invariant(:max_len, ::Integer) { |val, max_len| val.size <= max_len }
      invariant(:min_len, ::Integer) { |val, min_len| val.size >= min_len }
      invariant(:len_eq, ::Integer) { |val, len| val.size == len }
    end
  end
end
