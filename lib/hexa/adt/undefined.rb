# frozen_string_literal: true

module Hexa
  module Adt
    class Undefined
      def self.instance
        @instance ||= new
      end

      def self.construct(val, _options = {})
        if val.is_a?(Undefined)
          [val, nil]
        else
          context.error(:format)
          [nil, true]
        end
      end
    end
  end
end
