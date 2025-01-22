# frozen_string_literal: true

module Hexa
  module Pipes
    class Pipe
      attr_reader :input_type, :output_type, :fn

      def initialize(input: nil, output: nil, &block)
        raise(ArgumentError, "inp: expected #{Class}") if input && !input.is_a?(Class)
        raise(ArgumentError, "out: expected #{Class}") if output && !output.is_a?(Class)
        raise(ArgumentError, 'block is missed') unless block

        @input_type = input
        @output_type = output || input
        @fn = block
      end

      def to_proc
        proc { |payload| call(payload) }
      end

      def call(inp)
        inp_monad = inp.is_a?(Monad) ? inp : Success.new(inp)
        assert_input!(inp_monad)

        out_monad = exec(inp_monad)

        assert_output!(out_monad)

        out_monad
      end

      def exec(monad)
        if monad.is_a?(Success)
          proceed(monad)
        else
          monad
        end
      end

      def proceed(monad)
        monad
      end

      private

      def assert_input!(monad)
        return unless input_type
        return unless monad.is_a?(Success)
        return if monad.result.is_a?(input_type)

        raise ArgumentError, "#{input_type} expected"
      end

      def assert_output!(monad)
        raise('Monad expected') unless monad.is_a?(Monad)

        return if output_type.nil?
        return unless monad.is_a?(Success)
        return if monad.result.is_a?(output_type)

        raise ArgumentError, "#{output_type} expected"
      end
    end
  end
end
