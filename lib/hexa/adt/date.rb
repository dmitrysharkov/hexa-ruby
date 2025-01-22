module Hexa
  module Adt
    class Date < Scalar
      self.base_class = ::Date

      invariant(:gt, ::Date) { |val, base| val > base }
      invariant(:gteq, ::Date) { |val, base| val >= base }
      invariant(:lt, ::Date) { |val, base| val < base }
      invariant(:lteq, ::Date) { |val, base| val <= base }

      coerce ::String do |val|
        [::Date.parse(val), true]
      rescue ::Date::Error
        [nil, false]
      end

      serialize_as(::String, &:to_s)
    end
  end
end
