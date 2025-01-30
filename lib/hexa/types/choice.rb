module Hexa
  class Choice < Hash
    extend Type
    include Value

    prototype!

    class << self
      attr_accessor :items
      private :items=


      def create(first)
        Class.new(Choice) do
          self.items = [first]
        end
      end

      def |(other)
        items << other
        self
      end
    end
  end
end
