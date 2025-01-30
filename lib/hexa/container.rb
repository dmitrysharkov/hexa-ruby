module Hexa
  module Container
    # STAND_TYPES = %i[Int Str Float Bool]

    def self.included(mod)
      super

      mod.extend(Dsl)

      # STAND_TYPES.each { |t| mod.const_set(t, Hexa.const_get(t)) }
      mod.extend(ClassMethods)
    end
  end
end
