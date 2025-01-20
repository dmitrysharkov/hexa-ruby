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
            [arr.freeze, nil]
          else
            [nil, context.errors]
          end
        end

        def write_to_stream(list, stream)
          stream.start_array(self, list)

          list.each.with_index do |val, idx|
            next if val.is_a?(Undefined)

            last = (idx == list.size - 1)
            stream.start_array_item(self, list, val, idx, last)
            item_type.write_to_stream(val, stream)
            stream.end_array_item(self, list, val, idx, last)
          end
          stream.end_array(self, list)
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
