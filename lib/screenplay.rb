$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'json'

require 'screenplay/datatype-extensions'
require 'screenplay/configuration'
require 'screenplay/cast'
require 'screenplay/actor'
require 'screenplay/scenarios'

module Screenplay
	extend self

	def prepare
		Configuration.load
		Cast.autoload
		Scenarios.autoload
	end

	def run(options = {})
		options[:quiet] ||= false
		options[:human_friendly] ||= false

		raise Exception.new('ERROR: Couldn\'t find any scenarios to play.') if Scenarios.size == 0

		# First check if we know all needed actors
		each_scene { | scenario_name, actor_name  |
			raise UnknownActorException.new(scenario_name, actor_name) if Cast.get(actor_name).nil?
		}

		each_scene { | scenario_name, actor_name, params, input, index |
			puts "-- Scenario #{scenario_name} - Actor #{actor_name} --" unless (options[:quiet])
			begin
				output = Cast.get(actor_name).play(params, input)
			rescue Exception => e
				raise ScenarioFailedException.new(scenario_name, index, actor_name, e.message)
			end
			output.symbolize_keys!
			unless (options[:quiet])
				output_str = options[:human_friendly] ? JSON.pretty_generate(output) : output.to_s
				puts "Result:\n#{output_str}"
				puts ''
			end
			output
		}
	end

	def each_scene
		Scenarios.each { | scenario_name, scenario |
			input = {}
			index = 0
			scenario.each { | actor_name, params |
				input = yield scenario_name, actor_name, params, input, index
				index += 1
			}
		}
	end

end