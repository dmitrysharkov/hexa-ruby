# frozen_string_literal: true

module Hexa
  module Values
    class BuilderContext
      def self.init(source)
        case source
        when Hash then new(source)
        when BuilderContext then source
        else
          raise ArgumentError, "#{Hash} or #{BuilderContext} expected", caller[1..]
        end
      end

      attr_reader :current_path, :errors, :options

      def initialize(options)
        raise ArgumentError, "#{Hash} expected", caller[1..] unless options.is_a?(Hash)

        @options = options
        @current_path = []
        @errors = []
      end

      def error(invariant, *attributes, at: [])
        if_option :raise_at do |stack|
          raise ArgumentError, "#{invariant}(#{attributes.join('.')}) at #{(current_path + at).join('.')}", stack
        end

        errors << [current_path + at, invariant, attributes]
      end

      def option?(name)
        options.key?(name)
      end

      def if_option(name)
        return unless option?(name)

        yield options[name]
      end

      def push(path_item)
        current_path << path_item

        return unless block_given?

        val = yield
        pop
        val
      end

      def pop
        current_path.pop
      end

      def errors?
        errors.any?
      end
    end
  end
end
