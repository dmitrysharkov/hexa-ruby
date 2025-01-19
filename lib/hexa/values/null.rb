# frozen_string_literal: true

module Hexa
  module Values
    class Null < ::NilClass
      include ScalarMixin
    end
  end
end
