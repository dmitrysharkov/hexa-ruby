module Hexa
  module Projection
    EvolveHandler = Struct.new(:event_class, :handler)

    def self.evolve_handlers
      @event_handlers ||= []
    end
  end
end
