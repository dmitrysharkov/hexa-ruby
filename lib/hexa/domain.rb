module Hexa
  class Domain < Scope
    class << self
      def aggregate(id_type)

      end
      def decide(command, *models)
        events = models.last
        models = models[..-2]

        decider = tuple[command, *models] >> list.of(events)
        command_handler = command >> list.of(events)

        repository_invokes = models.map { |model| command >> model }
                                   .map { |fn| imports.detect { |x| x == fn } }

        command_to_models = repository_invokes.reduce(all_of) { |el, memo| memo.map(el.curry(command)) }

        implement decider do |command, **models|

        end

        export command.name.to_sym => command_handler

        decider
      end
    end
  end
end
