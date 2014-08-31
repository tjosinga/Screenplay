require File.join(File.dirname(__FILE__), '..', 'actor')

module Screenplay

	class DataActor < Actor

		def play(params, input)
			input.merge!(params)
			return input
		end

	end

end