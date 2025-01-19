# frozen_string_literal: true

module Hexa
  module Values
    class RecordBuilder
      attr_reader :attributes, :attributes_map

      def initialize(attributes)
        @attributes = attributes
        @attributes_map = attributes.map { |attr| [[attr.name, attr], [attr.name.to_s, attr]] }.flatten(1).to_h
      end

      def call(object, source, context)
        if source.respond_to?(:deconstruct_keys)
          build_from_hash(object, source, context)
        elsif source.respond_to?(:deconstruct)
          build_from_array(object, source, context)
        else
          raise(ArgumentError, "#{Array} or #{Hash} expected")
        end
      end

      private

      def build_from_hash(object, hash, context)
        used_attrs = []
        hash.each do |key, val|
          attr = attributes_map[key]

          next unless attr

          used_attrs << attr.name
          context.push(attr.name) do
            build_attr(object, attr, val, context)
          end
        end

        build_missed_attrs(object, used_attrs, context)
      end

      def build_from_array(object, arr, context)
        used_attrs = []
        arr.each.with_index do |val, idx|
          next if idx >= attributes.size

          attr = attributes[idx]

          used_attrs << attr.name

          context.push(idx) do
            build_attr(object, attr, val, context)
          end
        end

        build_missed_attrs(object, used_attrs, context)
      end

      def build_missed_attrs(object, used_attrs, context)
        return if used_attrs.size == attributes.size

        attributes.reject { |attr| used_attrs.include?(attr.name) }
                  .each { |attr| build_attr(object, attr, Undefined.instance, context) }
      end

      def build_attr(object, attr, src, context)
        val, = attr.type.construct(src, context)
        object.send(attr.setter, val)
      end
    end
  end
end
