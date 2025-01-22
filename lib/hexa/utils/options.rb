module Hexa
  module Pipes
    class Options
      Option = Struct.new(:name, :default, :validator)

      attr_reader :options, :block

      def initialize
        @options = []
        @block = nil
      end

      def add_option(name, default, validator)
        @options << Option.new(name.to_sym, default, validator)
      end

      def add_block(name, default, validator)
        @block = Option.new(name.to_sym, default, validator)
      end

      def validate(caller, kw_args, passed_block)
        (validate_options(caller, kw_args) + validate_block(caller, passed_block)).to_h
      end

      def validate_options(caller, kw_args)
        errors = []
        options.map do |opt|
          val = kw_args.key?(opt.name) ? kw_args[opt.name] : opt.default

          opt.validator&.call(val, errors)

          raise(ArgumentError, "#{opt.name}: #{errors.join(' ')}", caller) unless errors.empty?

          [opt.name, val]
        end
      end

      def validate_block(caller, passed_block)
        return [] unless block

        errors = []

        block.validator&.call(passed_block, errors)

        raise(ArgumentError, "block: #{errors.join(' ')}", caller) unless errors.empty?

        [block.name, passed_block]
      end

      def inherit(prototype)
        prototype.options.each { |opt| options << opt }
        @block = prototype.block
      end
    end
  end
end
