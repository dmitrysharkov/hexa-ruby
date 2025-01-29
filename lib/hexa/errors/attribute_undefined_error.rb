module Hexa
  class UnexpectedArgumentClassError < StandardError
    def initialize(name)
      super("Attribute #{name} was not defined")
    end
  end
end
