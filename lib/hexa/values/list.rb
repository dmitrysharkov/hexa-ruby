# frozen_string_literal: true

module Hexa
  module Values
    class List
      class << self
        attr_reader :item_type

        def item(type)
          @item_type = type
        end

        def of(type)
          Class.new(List) { item type }
        end

        def |(other)
          Union.new(self, other)
        end

        def construct(source, options = {})
          context = BuilderContext.init(options)

          unless source.is_a?(Enumerable)
            context.error(:format, :array)
            return [nil, context.errors]
          end

          errors_before = context.errors.size
          arr = source.map.with_index do |src, idx|
            context.push(idx) { item_type.construct(src, context).first }
          end

          if context.errors.size == errors_before
            [arr, nil]
          else
            [nil, context.errors]
          end
        end

        def write_to_json(val, stream)
          stream.write('[')
          cnt = 0
          val.each do |x|
            next if x.is_a?(Undefined)

            stream.write(',') if cnt > 1

            item_type.write_to_json(x, stream)
            cnt += 1
          end
          stream.write(']')
        end

        def inherited(subclass)
          super
          subclass.item(item_type)
          subclass.invariants.inherit(invariants)
        end

        include InvariantsMixin
      end
    end
  end
end
