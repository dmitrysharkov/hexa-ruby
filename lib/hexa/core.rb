module Hexa
  module Core
    def self.registry
      @registry
    end

    def self.registry=(r)
      raise(ArgumentError, 'Hexa::Registry expected', caller[1..-1]) unless r.is_a?(Registry)

      @registry = r
    end

    def self.add(clazz, &block)
      raise(ArgumentError, 'Class expected', caller[1..-1]) unless clazz.is_a?(clazz)

      (@registry ||= Registry.new).add(clazz, &block)
    end
  end
end
