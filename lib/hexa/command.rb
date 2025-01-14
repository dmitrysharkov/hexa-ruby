module Hexa
  module Command
    def self.included(base)
      base.class_eval { include Message::Methods }
      base.extend(Message::ClassMethods)
    end
  end
end
