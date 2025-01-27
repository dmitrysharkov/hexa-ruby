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

      def seal
        # 1. Iterate all constants. Find those which are types
        # 2. Inflect names
        # 3. Save to types map
        # 4. Define methods
        types { |_, v| v.is_a?(FuncType) && v.singleton?).each do |name, type|
          define_method(name) { |*args, **kv_args| type.call(self, *args, **kv_args).to_result(return_results )  }
        end

        if const_defined?(:Default)
          default = const_get(:Default)
          define_method(:call) { |*arg,  **kw_args| default.call(self, *arg, **kw_args).to_result(return_results ) }
        end
      end
    end

    attr_reader :params

    def to_proc(name = nil)
      raise "#{name} is not a function" unless name && !(fn.is_a?(FuncType) && fn.singleton?)

      fn = name ? types[name] : method(:call)

      proc { |*arg, **kw_args| fn.call(self, *arg, **kw_args).to_result(return_results ) }
    end

    attr_reader :return_results

    def initialize(*args, **kw_args)
      @params = init_type.counstruct(*args, **kw_args)
      @return_results = false
    end

    def to_result
      @return_results = true
      self
    end
  end
end
