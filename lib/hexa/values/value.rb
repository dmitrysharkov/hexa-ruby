# frozen_string_literal: true

module Hexa
  class Value
    class << self
      def inherit(*args, **kw_args, &block)
        Class.new(self, &block).tap { |subclass| subclass.type.apply_short_cuts(subclass, *args, **kw_args) }
      end

      def [](*args, **kw_args, &block)
        inherit(*args, **kw_args, &block)
      end

      def inherited(subclass)
        super
        subclass.type = type.inherit
      end

      def validate(*args)
        subclass.type.validate(*args)
        self
      end

      def desc(description)
        subclass.type.description = description
        self
      end

      def todo(todo)
        subclass.type.todos << todo
        self
      end

      def constraint(*args, &block)
        subclass.type.constraint(*args, &block)
        self
      end
    end
  end
end
