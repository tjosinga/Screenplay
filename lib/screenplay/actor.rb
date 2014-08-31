require 'screenplay/cast'
require 'screenplay/configuration'

module Screenplay

	class MethodNotImplemented < Exception

		def initialize(name)
			super("Method #{name} is not implemented.")
		end

	end


	class UnknownActorException < Exception

		def initialize(scenario, name)
			super("The scenario #{scenario} uses unknown actor #{name}.")
		end

	end

	class Actor

		attr_reader :name

		def initialize(name)
			@name = name.to_sym
			configure(Configuration[@name] || {})
		end

		def self.descendants
			ObjectSpace.each_object(Class).select { | klass | klass < self }
		end

		def configure(config = {})
			# Not needed to override this, but might be useful
		end

		def play(params, input)
			raise MethodNotImplemented.new('play')
		end

	end

end