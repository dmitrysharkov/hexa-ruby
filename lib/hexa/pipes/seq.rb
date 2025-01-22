# frozen_string_literal: true

module Hexa
  module Pipes
    class Seq < Pipeline
      def self.output_type
        pipes.last.pipe_class.output_type
      end

      def initialize
        super

        inp = self.class.input_type

        @pipes = self.class.pipes.map do |blueprint|
          block = blueprint.method_name ? method(blueprint.method_name) : blueprint.block
          out = blueprint.options[:output] || inp
          options = blueprint.options.merge(input: inp, output: out)
          inp = out

          blueprint.pipe_class.new(**options, &block)
        end
      end

      def call(inp)
        val = inp
        pipes.each { |pipe| val = pipe.call(val) }
        val
      end
    end
  end
end
