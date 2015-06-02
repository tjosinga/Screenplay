$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'json'

require 'screenplay/datatype-extensions'
require 'screenplay/configuration'
require 'screenplay/cast'
require 'screenplay/actor'
require 'screenplay/scenarios'

module Screenplay
	extend self

	attr_reader :options

	def prepare
		Configuration.load
		Cast.autoload
		Scenarios.autoload
	end

	def play(options = {})
		@options = options
		@options[:quiet] ||= false
		@options[:human_friendly] ||= false
		@options[:show_output] = @options[:show_output] && !@options[:quiet]

		raise 'ERROR: Couldn\'t find any scenarios to play.' if Scenarios.size == 0

		# First check if we know all needed actors
		each_scene { | scenario_name, actor_name  |
			raise UnknownActorException.new(scenario_name, actor_name) if Cast.get(actor_name).nil?
		}

		each_scene { | scenario, actor_name, params, input, index |
			puts "##### #{scenario.name} - #{actor_name}: #####" if !@options[:quiet] && @options[:show_output]
			params ||= {}
			begin
				output = Cast.get(actor_name).play(params, input)
			rescue Exception => e
				raise ScenarioFailedException.new(scenario, index, actor_name, e)
			end
			output.symbolize_keys!
			unless (@options[:quiet])
				if (@options[:show_output])
					puts 'output = ' + (@options[:human_friendly] ? JSON.pretty_generate(output) : output).to_s
					puts ''
				else
					STDOUT << '.'
				end
			end
			output
		}
		puts '' unless @options[:quiet]
	end

	def each_scene
		Scenarios.each { | scenario |
			input = {}
			index = 1
			scenario.each { | actor_name, params |
				input = yield scenario, actor_name, params, input, index
				index += 1
			}
		}
	end

end