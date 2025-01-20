# frozen_string_literal: true

module Hexa
  module Values
    class List < ::Array
      class << self
        attr_reader :item_type

        def item(type)
          @item_type = type
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
          source.each.with_index do |src, idx|
            context.push(idx) { arr << item_type.construct(src, context).first }
          end

          if context.errors.size == errors_before
            [arr.freeze, nil]
          else
            [nil, context.errors]
          end
        end

        def inherited(subclass)
          super
          subclass.item(item_type)
          subclass.invariants.inherit(invariants)
        end

        def [](item_type, **validators)
          Class.new(List) do
            item(item_type)
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
    end
  end
end
