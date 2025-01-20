# frozen_string_literal: true

module Hexa
  module Values
    class Bool
      include ScalarMixin

      self.base_class = TrueClass
    end
  end
end
