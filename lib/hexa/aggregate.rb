module Hexa
  module Aggregate
    CommandHandler = Struct.new(:command_class, :tool_classes, :handler)
    EvolveHandler = Struct.new(:event_class, :handler)
    ReactHandler = Struct.new(:event_class, :tool_classes, :handler)

    def self.command_handlers
      @command_handlers ||= []
    end

    def self.evolve_handlers
      @event_handlers ||= []
    end

    def self.react_handlers
      @react_handlers ||= []
    end

    def self.decide(command_class, *tools, &block)
      command_handlers << CommandHandler.new(command_class, tools, lambda(&block))
    end

    def self.evolve(event_class, &block)
      evolve_handlers << EvolveHandler.new(event_class, lambda(&block))
    end

    def self.react(event_class, *tools, &block)
      react_handlers << ReactHandler.event_class(event_class, *tools, lambda(&block))
    end
  end
end
