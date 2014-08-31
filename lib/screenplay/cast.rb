module Screenplay

	# The Cast module is a singleton which is available for actors to register themselves and make themselves available.
	module Cast
		extend self

		@actors = {}

		include Enumerable

		def register(actor)
			raise Exception.new("Actor #{actor.name} is already registered.") if @actors.include?(actor.name)
			@actors[actor.name.to_sym] = actor
		end

		def each
			@actors.each { | k, v | yield k, v }
		end

		def get(actor)
			@actors[actor.to_sym]
		end

		def autoload
			# Require all standard actors
			Dir[File.dirname(__FILE__) + '/actors/*.rb'].each { | filename |
				require filename
			}
			## Require custom actors
			@actors_path = $SCREENPLAY_ACTORS_DIR || Configuration[:general][:actors_dir] rescue  File.join(Configuration.path, 'actors')
			Dir[@actors_path + '/**/*.rb'].each { | filename |
				require filename
			}

			## Create an instance of each actor and register it to the cast
			Actor.descendants.each { | klass |
				name = klass.name.match(/(\w+)(Actor)?$/)[0].gsub(/Actor$/, '').snake_case
				register(klass.new(name))
			}
		end


	end

end