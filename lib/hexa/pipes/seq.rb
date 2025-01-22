module Hexa
  module Pipes
    class Seq < Pipeline
      def perform(monad)
        self.class.pipes.each do |pipe|
          break unless monad.is_a?(Success)

          monad = pipe.call(self, monad.result)
        end

        monad
      end
    end
  end
end
