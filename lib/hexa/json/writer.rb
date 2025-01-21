# frozen_string_literal: true

module Hexa
  module Json
    class Writer
      def initialize(io_stream, **options)
        @io_stream = io_stream
        @options = options
      end

      def write(data, type = nil)
        case data
        when Adt::RecordMixin then write_record(data)
        when Adt::List then write_array(data)
        else write_scalar(data, type)
        end
      end

      private

      def write_record(data)
        out('{')
        first = true
        data.class.attributes.each do |attr|
          next unless data.attribute_defined?(attr.name)

          out(',') unless first
          first = false

          out(attr.camelized_name_str, ':')

          write(data.attribute_value(attr.name), attr.type)
        end
        out('}')
      end

      def write_array(data)
        out('[')
        first = true
        data.each.with_index do |val, idx|
          next if val.is_a?(Adt::Undefined)

          out(',') unless first
          first = false

          if idx < data.class.prefix_items.size
            write(val, data.class.prefix_items[idx])
          else
            write(val, data.class.items)
          end
        end
        out(']')
      end

      def write_scalar(data, type)
        type = type.value_type(data) if type.is_a?(Adt::Union)
        val = type.serialize_value(data)
        case val
        when TrueClass then out('true')
        when FalseClass then out('false')
        when String then out('"', val.gsub('\\', '\\\\').gsub('"', '\\"'), '"')
        when Integer, Float then out(val.to_s)
        when NilClass then out('null')
        else raise("Unexpected value #{val}")
        end
      end

      def out(*args)
        @io_stream.write(*args)
      end
    end
  end
end
