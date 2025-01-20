# frozen_string_literal: true

module Hexa
  module Json
    class WriteStream < Values::WriteStream
      def start_object(_record)
        write('{')
      end

      def end_object(_record)
        write('}')
      end

      def start_object_attribute(_record, attr, _value, _index, _is_last)
        write(attr.camelized_name_str, ':')
      end

      def end_object_attribute(_record, _attr, _value, _index, is_last)
        write(',') unless is_last
      end

      def start_array(_arr)
        write('[')
      end

      def end_array(_arr)
        write(']')
      end

      def start_array_item(_arr, _value, _index, _is_last); end

      def end_array_item(_record, _value, _index, is_last)
        write(',') unless is_last
      end

      def write_int(value)
        write(value.to_s)
      end

      def write_str(value)
        write('"', value.gsub('\\', '\\\\').gsub('"', '\\"'), '"')
      end

      def write_real(value)
        write(value.to_s)
      end

      def write_bool(value)
        write(value ? 'true' : false)
      end

      def write_null
        write('null')
      end
    end
  end
end
