module Hexa
  class Int < Integer
    extend Type
    include Value

    prototype! do |val|
      val if val.is_a?(Integer)
    end
  end
end
