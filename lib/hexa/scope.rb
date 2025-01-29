module Hexa
  class Scope
    class << self

      def type(type_builder)
        # it will receive a type builded and return a type
        type_builder.type
      end

      def init(type)
        # @init_type = type
        # constructor = const func[nothing, type]
        #
        # implement(constructor, &:params)
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

      def const(name, type = nil)
        # type, name = type ? [type, name] : [name, nil]
        # type.singleton.freeze
      end

      def constants(*types)
        types.each(&:singleton).map(&:freeze)
      end

      def export(fn)

      end

      def export_default(fn)

      end
    end

    attr_reader :params

    def to_proc(name = nil)
      # fn = types[name]
      #
      # raise "#{name} is not a function" unless name && !(fn.is_a?(FuncType) && fn.singleton?)
      #
      # proc { |*arg, **kw_args| invoke(fn, *arg, **kw_args).to_result(return_results ) }
    end

    attr_reader :return_results

    def initialize(*args, **kw_args)
      # @params = init_type.counstruct(*args, **kw_args)
      # @return_results = false
    end

    def to_result
      # @return_results = true
      # self
    end

    private

    def invoke(name, *args, **kw_args)
      input = kw_args.empty? ? args : args + [kw_args]
      result = input_type.construct(input)

      if result.success?
        implementation.call(input)
      else
        result
      end

      # fn.call(self, *args, **kw_args)
    end
  end
end
