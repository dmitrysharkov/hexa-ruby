module Hexa
  class Scope
    class << self
      attr_reader :init_type

      def implement(func=nil, &block)
      end

      def type(type_builder)
        # it will receive a type builded and return a type
      end

      def init(type)
        @init_type = type
        constructor = const func[nothing, type]

        implement(constructor, &:params)
      end

      def nothing
        NothingType.prototype
      end

      def tuple(*args, **kw_args)
        TupleType.prototype
      end

      def str(*args, **kw_args)
        StrType.prototype
      end

      def int(*args, **kw_args)
        IntType.prototype
      end

      def date
        DateType.prototype
      end

      def list(*args, **kw_args)
        ListType.prototype
      end

      def enum(*args, **kw_args)
        # proc do |*args, **kw_args|
        #   name = args.unshift
        #   kw_args += args.map { |x| [x, x] }.map(&:to_h)
        #   c = constants(**kw_args)
        #   ch = choice.of(**c)
        #   ch.key(:name) if name
        #   ch
        # end
      end

      def fn(name, type = nil, &block); end

      # record is just a syntax sugar for a tuple
      def record(*args, **kw_args)

      end

      def choice(*args, **kw_args)
        ChoiceType.prototype
      end

      def func(*argc)
        FuncType.prototype
      end

      def pipe(*args, &block)
      end

      def maybe
      end

      # output will be a tuple on success and
      def all_of(*args)
        # 1. check all args are constant functions
        # 2. check all args have the same input type
        # 3. check all args have a monadic either or non monadic output type
        # 4. build output type
        # 5. build const func type
        # 6. build trusted implementation
        # 7. return const input type
      end

      # output will be a list
      def any_of(*args)
        # 1. check all args are constant functions
        # 2. check all args have the same input type
        # 3. check all args have a monadic either or non monadic output type
        # 4. build output type
        # 5. build const func type
        # 6. build trusted implementation
        # 7. return const input type
      end

      def one_of
      end

      def either(type)
      end

      def const(name, type = nil)
        type, name = type ? [type, name] : [name, nil]
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

      def export(default = nil, **kw_args)
        # check if implemented

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
