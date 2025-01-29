module Hexa
  class UnexpectedArgumentClassError < ::ArgumentError
    def initialize(type)
      super("Expected #{type}")
    end
  end
end
