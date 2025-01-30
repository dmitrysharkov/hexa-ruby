module Hexa
  class Tuple < Hash
    extend Type
    include Value

    prototype!

    class << self
      attr_accessor :items
      private :items=

      def create(one)
        Class.new(Tuple) do
          self.items = [one]
        end
      end

      def *(other)
        items << other
        self
      end
    end
  end
end
