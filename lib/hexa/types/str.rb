module Hexa
  class Str < String
    extend Type
    include Value

    prototype!
  end
end
