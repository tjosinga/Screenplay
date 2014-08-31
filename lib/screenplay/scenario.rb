require 'yaml'

module Screenplay

	class ScenarioFailedException < Exception
		def initialize(scenario, index, actor_name, message)
			super("FAILED: Scenario #{scenario.name}, scene #{index} of #{scenario.size}, actor #{actor_name}: #{message}")
		end
	end

	class Scenario

		include Enumerable

		attr_reader :name

		def initialize(name, filename)
			@name = name
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

		def size
			@actions.size
		end

	end

end