# frozen_string_literal: true

module Hexa
  module Json
    class WriteStream
      def initialize(io_stream, **options)
        @io_stream = io_stream
        @options = options
      end

      def write(data, type = nil)
        case data
        when Values::RecordMixin then write_record(data)
        when Values::List then write_array(data)
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
        data.each.with_index do |val|
          next if val.is_a?(Values::Undefined)

          out(',') unless first
          first = false

          write(val, data.class.item_type)
        end
        out(']')
      end

      def write_scalar(data, type)
        type = type.value_type(data) if type.is_a?(Values::Union)
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

      # def start_object(_record)
      #   write('{')
      # end
      #
      # def end_object(_record)
      #   write('}')
      # end
      #
      # def start_object_attribute(_record, attr, _value, _index, _is_last)
      #   write(attr.camelized_name_str, ':')
      # end
      #
      # def end_object_attribute(_record, _attr, _value, _index, is_last)
      #   write(',') unless is_last
      # end
      #
      # def start_array(_arr_type, _arr)
      #   write('[')
      # end
      #
      # def end_array(_arr_type, _arr)
      #   write(']')
      # end
      #
      # def start_array_item(_arr_type, _arr, _value, _index, _is_last); end
      #
      # def end_array_item(_arr_type, _arr, _value, _index, is_last)
      #   write(',') unless is_last
      # end
      #
      # def write_int(value)
      #   write(value.to_s)
      # end
      #
      # def write_str(value)
      #   write('"', value.gsub('\\', '\\\\').gsub('"', '\\"'), '"')
      # end
      #
      # def write_real(value)
      #   write(value.to_s)
      # end
      #
      # def write_bool(value)
      #   write(value ? 'true' : false)
      # end
      #
      # def write_null
      #   write('null')
      # end
    end
  end
end
