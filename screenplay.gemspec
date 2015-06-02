Gem::Specification.new { | gem |
	gem.name            = 'screenplay'
	gem.version         = '0.1.5'
	gem.date            = '2015-06-02'
	gem.summary         = 'Screenplay'
	gem.description     = 'Screenplay helps with testing data driven applications like RESTful API\'s by writing scenario\'s in Yaml.'
	gem.authors         = ['Taco Jan Osinga']
	gem.email           = 'info@osingasoftware.nl'
	gem.files           = `git ls-files lib`.split("\n") + %w(LICENSE Gemfile)
	gem.executables     = ['screenplay']
	gem.require_paths   = ['lib']
	gem.homepage        = 'https://github.com/tjosinga/screenplay'
	gem.license         = 'MIT'

	# package dependencies
	gem.add_runtime_dependency('rest-client', '~> 1.7')
	gem.add_runtime_dependency('highline', '~> 1.6')

}
