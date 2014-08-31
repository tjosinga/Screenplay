require 'screenplay/scenario'

module Screenplay

	module Scenarios
		extend self

		include Enumerable

		@scenarios = {}

		def register(filename)
			name = filename.gsub(@path, '') unless @path.empty?
			@scenarios[name] = Scenario.new(filename)
		end

		def autoload
			@path = $SCREENPLAY_SCENARIOS_DIR || Configuration[:general][:scenarios_dir] rescue File.join(Configuration.path, 'scenarios')
			load_path(@path)
		end

		def load_path(path)
			yml_files = File.join(path, '**', '*.yml')
			Dir[yml_files].each { | filename | register(filename) }
		end

		def size
			@scenarios.size
		end

		def each
			@scenarios.each { | k, v | yield k, v }
		end

	end

end