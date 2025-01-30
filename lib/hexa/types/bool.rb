module Hexa
  class Bool < TrueClass
    extend Type
    include Value

    prototype! do |val, _clz|
      val if val.is_a?(TrueClass) || val.is_a?(FalseClass)
    end
  end
end
