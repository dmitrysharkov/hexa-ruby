module Hexa
  module Type
    def key
      @key
    end

    def key=(key)
      @key = key
    end

    def *(other)
      Tuple.create(self) * other
    end

    def |(other)
      Choice.create(self) | other
    end

    def &(other)
      # check it's a function taking this type and returning bool

      create_sibling.tap { |sibling| sibling.constraints << other }
    end

    def [](key)
      create_sibling.tap { |sibling| sibling.key = key }
    end

    def create_sibling
      Class.new(prototype).tap do |cls|
        cls.key = key
        constraints.each { |c| cls.constraints << c }
      end
    end

    def constraints
      @constraints ||= []
    end

    def prototype!(&block)
      @coercer = block if block
      @prototype = true
      @constraints = []
    end

    def prototype?
      @prototype || false
    end

    def prototype
      prototype? ? self : superclass
    end

    def cast(val)
      if prototype?
        return val if val.is_a?(self)

        res = @coercer.call(val, self)

        raise(ArgumentError, "Can't coerce #{val} to #{self}") unless res

        res
      else
        prototype.cast(val)
      end
    end
  end
end
