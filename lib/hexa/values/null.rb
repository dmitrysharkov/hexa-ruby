# frozen_string_literal: true

module Hexa
  module Values
    class Null < NilClass
      include Scalar
    end
  end
end
