require File.join(File.dirname(__FILE__), '..', 'actor')

module Screenplay

	class CacheActor < Actor

		attr_reader :cache

		def play(params = {}, input = {})
			@cache ||= {}
			output = {}
			params.each { | action, values |
				output = input.dup if action == :merge

				if action == :clear
					@cache.clear
				elsif action == :set
					values.each { | cache_key, input_key  |
						@cache[cache_key.to_sym] = (input_key == '$input'.to_sym) ? input : input[input_key.to_sym]
					}
				elsif (action == :merge || action == :get)
					values.each { | input_key, cache_key |
						output[input_key.to_sym] = @cache[cache_key.to_sym]
					}
				end
			}
			return output
		end

	end

end