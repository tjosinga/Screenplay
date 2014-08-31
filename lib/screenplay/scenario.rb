require 'yaml'

module Screenplay

	class ScenarioFailedException < Exception
		def initialize(scenario_name, index, actor_name, message)
			super("FAILED: Scenario #{scenario_name}, scene #{index}, actor #{actor_name}: #{message}")
		end
	end

	class Scenario

		include Enumerable

		def initialize(filename)
			@actions = YAML.load_file(filename)
			@actions.symbolize_keys!
		end

		def each
			@actions.each { | action |
				actor = action.keys[0]
				data = action[actor]
				yield actor, data
			}
		end

	end

end