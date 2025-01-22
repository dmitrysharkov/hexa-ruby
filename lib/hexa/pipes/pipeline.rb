# frozen_string_literal: true

module Hexa
  module Pipes
    class Pipeline
      PipeBlueprint = Struct.new(:pipe_class, :method_name, :options, :block)
      class << self
        attr_reader :input_type

        def input(input_type)
          @input_type = input_type
        end

        def pipes
          @pipes ||= []
        end

        def pipe(pipe_class, method_name = nil, **options, &block)
          raise(ArgumentError, 'a method name or a block has to be provided') unless method_name.nil? ^ block.nil?
          raise(ArgumentError, 'pipe_class has to be a pipe') unless pipe_class.is_a?(Class) && pipe_class < Pipe

          pipes << PipeBlueprint.new(pipe_class, method_name, options, block)
        end

        def bind(method_name = nil, out: nil, &block)
          pipe(Bind, method_name, out: out, &block)
        end

        def map(method_name = nil, out: nil, &block)
          pipe(Map, method_name, out: out, &block)
        end

        def select(method_name = nil, out: nil, &block)
          pipe(Filter, method_name, out: out, &block)
        end

        def reject(method_name = nil, out: nil, &block)
          pipe(Filter, method_name, out: out, inverse: true, &block)
        end

        def inherited(subclass)
          super
          pipes.each { |pipe| subclass.pipes << pipe }
        end

        def const_missing(name)
          case name
          when :Success then Success
          when :Failure then Failure
          when :Skip then Skip
          end
        end
      end

      attr_reader :pipes

      def to_proc
        proc { |payload| call(payload) }
      end
    end
  end
end
