require 'yaml'

module Screenplay

	class ScenarioFailedException < StandardError
		attr_reader :inner_exception

		def initialize(scenario, index, actor_name, exception)
			@inner_exception = exception
			super("FAILED: Scenario #{scenario.name}, scene #{index} of #{scenario.size}, actor #{actor_name}: #{exception.message}")
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