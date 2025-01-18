module Hexa
  module Values
    class Array
      class << self
        attr_reader :item_type

        def item(type)
          @item_type = type
        end

        def of(type)
          Class.new(Array) { item type }
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
      end
    end
  end
end
