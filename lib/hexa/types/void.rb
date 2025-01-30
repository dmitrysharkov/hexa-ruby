module Hexa
  class Void < NilClass
    extend Type
    include Value

    prototype!
  end
end
