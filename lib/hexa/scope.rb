module Hexa
  class Scope
    class << self
      attr_reader :init_type

      def implement(func=nil, &block)
      end

      def type(*types)
        return types.map(&:freeze) if types.size > 1

        types[0].tap(&:freeze)
      end

      def init(type)
        @init_type = type
        constructor = const func[nothing, type]

        implement(constructor, &:params)
      end

      def nothing
        NothingType.prototype
      end

      def tuple
        TupleType.prototype
      end

      def str
        StrType.prototype
      end

      def int
        IntType.prototype
      end

      def date
        DateType.prototype
      end

      def list
        ListType.prototype
      end

      def enum
        proc do |*args, **kw_args|
          name = args.unshift
          kw_args += args.map { |x| [x, x] }.map(&:to_h)
          c = constants(**kw_args)
          ch = choice.of(**c)
          ch.key(:name) if name
          ch
        end
      end

      # record is just a syntax sugar for a tuple
      def record

      end

      def choice
        ChoiceType.prototype
      end

      def func
        FuncType.prototype
      end

      def pipe
      end

      def maybe
      end

      def all_of
      end

      def any_of
      end

      def one_of
      end

      def const(type)
        type.singleton.freeze
      end

      def constants(*types)
        types.each(&:singleton).map(&:freeze)
      end

      # def export(default = nil, **exports)
      #   @default_function = default if default
      #   @exports = exports
      #   exports.each do |k, v|
      #     define_method(k) { |*args, **kw_args| v.call(*args, **kw_args) }
      #   end
      # end
      #
      # def default_function
      #   @default_function
      # end
      #
      # def exports
      #   @exports
      # end

      def export(*args, **kw_args)
        # check if implemented
        defaule = args.unshift
        @exports = default
      end

      def exports
        @exports
      end
    end

    attr_reader :params

    def call(*arg, **kw_args)
      exports = self.class.exports
      case exports
      when FuncType then self.class.exports.call(*arg, **kw_args)
      end
    end

    def to_proc
      proc { |*arg, **kw_args| exports.call(*arg, **kw_args) }
    end

    def invoke(name, *arg, **kw_args)
      self.class.exports[name].call(*arg, **kw_args)
    end

    def initialize(*args, **kw_args)
      @params = init_type.value_class.new(*args, **kw_args)
    end
  end
end
