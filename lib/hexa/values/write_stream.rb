# frozen_string_literal: true

module Hexa
  module Values
    class WriteStream
      attr_reader :io_stream, :options

      def initialize(io_stream, **options)
        @io_stream = io_stream
        @options = options
      end

      def start_object(record)
        raise NotImplementedError
      end

      def end_object(record)
        raise NotImplementedError
      end

      def start_object_attribute(record, attr, value, index, is_last)
        raise NotImplementedError
      end

      def end_object_attribute(record, attr, value, index, is_last)
        raise NotImplementedError
      end

      def start_array(arr_type, arr)
        raise NotImplementedError
      end

      def end_array(arr_type, arr)
        raise NotImplementedError
      end

      def start_array_item(arr_type, arr, value, index, is_last)
        raise NotImplementedError
      end

      def end_array_item(arr_type, arr, value, index, is_last)
        raise NotImplementedError
      end

      def write_int(value)
        raise NotImplementedError
      end

      def write_str(value)
        raise NotImplementedError
      end

      def write_real(value)
        raise NotImplementedError
      end

      def write_bool(value)
        raise NotImplementedError
      end

      def write_null
        raise NotImplementedError
      end

      private

      def write(*args)
        io_stream.write(*args)
      end
    end
  end
end
