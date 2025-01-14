module Hexa
  class Registry
    def initialzie
      @aggregates = []
      @commands_map = {}
      @events = []

      @tools_map = {}
    end


    def add(clazz, &block)
      if clazz < Aggregate
        add_aggregate(clazz, caller[1..-1])
      else add_tool(clazz, &block)
      end
    end

    private

    def add_aggregate(clazz, call_stack)
      @aggregates << clazz
      clazz.command_handlers.each do |ch|
        assert_command_handler(ch, call_stack)

        @commands_map[ch.command_class] = ch
      end
    end

    def add_tool(clazz, &block)
      @tools_map[clazz] = lambda(&block)
    end

    def assert_command_handler(ch, call_stack)
      already_defined = @commands_map.key?(ch.command_class)

      raise("Command handler for #{ch.command_class} is already defined", call_stack) if already_defined
    end
  end
end
