# frozen_string_literal: true

module Hexa
  module Values
    class Null
      include ScalarMixin

      self.base_class = NilClass

      coerce String do |val|
        if val == 'null' || val.empty?
          [nil, true]
        else
          [nil, false]
        end
      end
    end
  end
end
