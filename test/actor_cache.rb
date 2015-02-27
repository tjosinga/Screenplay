$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'screenplay/actors/cache'

module Screenplay

	class CacheActorTest < MiniTest::Unit::TestCase

		def setup
			@actor = CacheActor.new('cache')
		end

		def test_cache_actor
			input1 = { id: 'husker', name: 'William Adama' }
			input2 = { names: ['William Adama', 'Lee Adama'] }

			@actor.play({ set: {callsign: :id}}, input1 )
			assert_equal({ callsign: 'husker' }, @actor.cache)

			cached = { an_id: 'husker' }
			assert_equal(cached, @actor.play({get: {an_id: :callsign}}, input1))
			assert_equal(input1.merge(cached), @actor.play({merge: {an_id: :callsign}}, input1))

			@actor.play({clear: nil}, {})
			assert_equal({}, @actor.cache)

			@actor.play({set: {cached_names: :names}}, input2)
			assert_equal({cached_names: ['William Adama', 'Lee Adama']}, @actor.cache)

			@actor.play({clear: nil}, {})
			@actor.play({set: {cached_names: '$input'.to_sym}}, input2)
			assert_equal({cached_names: {names: ['William Adama', 'Lee Adama']}}, @actor.cache)
		end

	end

end