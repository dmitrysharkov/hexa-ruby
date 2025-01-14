module Hexa
  module Message
    module ClassMethods
      def schema(&block)
        @schema ||= Schema::Struct.new

        if block_given?
          Schema::Dsl.new(@schema).instance_exec(&block)
          @schema.freeze
        end

        @schema
      end
    end

    module Methods
      def initialize(*args, **kw_args)
        self.class.schema.inject(self, *args, **kw_args)
      end
    end
  end
end
