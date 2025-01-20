# frozen_string_literal: true

module Hexa
  module Values
    class Null
      include ScalarMixin

      self.base_class = NilClass
    end
  end
end
