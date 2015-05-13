require 'yaml'
require 'screenplay/datatype-extensions'

module Screenplay

	module Configuration
		extend self

		include Enumerable

		@config = {}

		def each
			@config.each { | k, v | yield k, v }
		end

		def [](key)
			@config[key]
		end

		def load(reload = false)
			return unless @config.empty? || reload
			@filename = $SCREENPLAY_CONFIGFILE || './config.yaml' || './config.yml'
			@config = YAML.load_file(@filename) if File.exists?(@filename)
			@config.symbolize_keys!
		end

		def path
			File.dirname(@filename) || './'
		end

		def to_h
			@config.to_h
		end

	end

end