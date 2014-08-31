require File.join(File.dirname(__FILE__), '..', 'actor')
require 'highline/import'

module Screenplay

	class PromptActor < Actor

		def play(params, input)
			output = input
			params.each { | key, title |
				output[key] = ask(title.replace_vars(input) + ': ') #{ | q | q.echo = true }
			}
			return output
		end

	end

end