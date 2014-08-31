$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'screenplay/actors/data'

module Screenplay

	class DataActorTest < MiniTest::Unit::TestCase

		def setup
			@actor = DataActor.new('data')
		end

		def test_data_actor
			input = { id: 'husker', name: 'William Adama' }
			assert_equal(input, @actor.play(input, {}))
		end

	end

end