require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/hexa/errors", "#{__dir__}/hexa/types",
                "#{__dir__}/hexa/types_dsl", "#{__dir__}/hexa/values")
loader.setup

module Hexa
end
