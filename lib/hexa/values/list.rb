# frozen_string_literal: true

module Hexa
  module Values
    class List < ::Array
      class << self
        def items_annotate(type)
          @items = type
        end

        attr_reader :items

        def prefix_items_annotate(*types)
          types.each { |t| prefix_items << t }
        end

        def prefix_items
          @prefix_items ||= []
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

          arr = new
          cnt = 0
          source.each do |src|
            context.push(cnt) do
              arr << if cnt < prefix_items.size
                       prefix_items[cnt].construct(src, context).first
                     else
                       if items
                         items.construct(src, context).first
                       else
                         context.error(:unexpected_item)
                         nil
                       end
                     end
            end
            cnt += 1
          end

          while cnt < prefix_items.size
            context.push(cnt) { context.error(:missed_item) }
            cnt += 1
          end

          if context.errors.size == errors_before
            [arr.freeze, nil]
          else
            [nil, context.errors]
          end
        end

        def inherited(subclass)
          super
          subclass.items_annotate(items)
          subclass.invariants.inherit(invariants)
          subclass.prefix_items_annotate(*prefix_items)
        end

        def [](items = nil, prefix_items: [], **validators)
          Class.new(List) do
            items_annotate(items)

            prefix_items = [prefix_items] unless prefix_items.is_a?(Array)
            prefix_items_annotate(*prefix_items)

            validators.each do |predicate, params|
              if params.is_a?(TrueClass)
                validate(predicate)
              else
                validate(predicate, *params)
              end
            end
          end
        end

        include InvariantsMixin
      end

      invariant(:max_len, ::Integer) { |val, max_len| val.size <= max_len }
      invariant(:min_len, ::Integer) { |val, min_len| val.size >= min_len }
      invariant(:len_eq, ::Integer) { |val, len| val.size == len }
      invariant(:uniq) { |val| val.size == val.uniq.size }
    end
  end
end
