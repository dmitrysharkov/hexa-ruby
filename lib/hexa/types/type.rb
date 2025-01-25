# frozen_string_literal: true

module Hexa
  class Type
    attr_reader :todos, :validators
    attr_accessor :description

    def self.prototype

    end

    def initialize(parent = nil)
      @parent = parent
      @todos = parent&.todos&.clone || []
      @validators = parent&.validators&.clone || []
    end

    def key(name)
      @key = name
      self
    end

    def wip
      @work_in_progress = true
      self
    end

    def apply_short_cuts(clazz, *args, **kw_args); end

    def validate(constraint, *params)
      @validators << [constraint, params]
      self
    end

    def singleton
      self
    end

    def inherit
      self.class.new(self)
    end

    def value_class

    end
  end
end
