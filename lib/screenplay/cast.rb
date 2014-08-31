module Screenplay

	# The Cast module is a singleton which is available for actors to register themselves and make themselves available.
	module Cast
		extend self

		@actors = []

		include Enumerable

		def register(actor)
			raise Exception.new("Actor #{actor.name} is already registered.") if @actors.include?(actor.name)
			@actors.push(actor)
			@actors.sort_by!{ | actor | actor.name }
		end

		def each
			@actors.each { | actor | yield actor }
		end

		def get(actor_name)
			@actors.each { | actor |
				return actor if actor.name == actor_name.to_sym
			}
			return nil
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