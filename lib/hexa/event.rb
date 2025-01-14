module Hexa
  module Event
    def self.included(base)
      base.class_eval { include Parsable::Methods }
      base.extend(Parsable::ClassMethods)
    end
  end
end
