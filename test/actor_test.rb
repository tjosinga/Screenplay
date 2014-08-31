$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'screenplay/actors/test'

module Screenplay

	class TestActorTest < MiniTest::Unit::TestCase

		def setup
			@actor = TestActor.new('test')
		end

		def test_lt
			assert_equal(true, @actor.test_lt(1, 2))
			assert_equal(false, @actor.test_lt(2, 2))
			assert_equal(false, @actor.test_lt(3, 2))

			assert_equal(false, @actor.test_lt('abc', 'aba'))
			assert_equal(false, @actor.test_lt('abc', 'abc'))
			assert_equal(true, @actor.test_lt('abc', 'abd'))
		end

		def test_lte
			assert_equal(true, @actor.test_lte(1, 2))
			assert_equal(true, @actor.test_lte(2, 2))
			assert_equal(false, @actor.test_lte(3, 2))

			assert_equal(false, @actor.test_lte('abc', 'aba'))
			assert_equal(true, @actor.test_lte('abc', 'abc'))
			assert_equal(true, @actor.test_lte('abc', 'abd'))
		end

		def test_eq
			assert_equal(true, @actor.test_eq(1, 1))
			assert_equal(false, @actor.test_eq(1, 2))

			assert_equal(true, @actor.test_eq('test', 'test'))
			assert_equal(false, @actor.test_eq('test', 'false test'))

			assert_equal(false, @actor.test_eq(true, false))
			assert_equal(true, @actor.test_eq(false, false))
		end

		def test_gte
			assert_equal(false, @actor.test_gte(1, 2))
			assert_equal(true, @actor.test_gte(2, 2))
			assert_equal(true, @actor.test_gte(3, 2))

			assert_equal(true, @actor.test_gte('abc', 'aba'))
			assert_equal(true, @actor.test_gte('abc', 'abc'))
			assert_equal(false, @actor.test_gte('abc', 'abd'))
		end

		def test_gt
			assert_equal(false, @actor.test_gt(1, 2))
			assert_equal(false, @actor.test_gt(2, 2))
			assert_equal(true, @actor.test_gt(3, 2))

			assert_equal(true, @actor.test_gt('abc', 'aba'))
			assert_equal(false, @actor.test_gt('abc', 'abc'))
			assert_equal(false, @actor.test_gt('abc', 'abd'))
		end

		def test_in
			assert_equal(true, @actor.test_in('test1', ['test1', 'test2', 'test3']))
			assert_equal(true, @actor.test_in(:test1, {test1: 'test', test2: 'test', test3: 'test'}))
			assert_equal(true, @actor.test_in('test', 'This is a test'))
			assert_equal(true, @actor.test_in(/\w+/, 'This is a test'))

			assert_equal(false, @actor.test_in('test4', ['test1', 'test2', 'test3']))
			assert_equal(false, @actor.test_in(:test4, {test1: 'test', test2: 'test', test3: 'test'}))
			assert_equal(false, @actor.test_in('test4', 'This is a test'))
			assert_equal(false, @actor.test_in('/\d+/', 'This is a test'))

			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_in('test', 1) }
			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_in(1, 1) }
			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_in(1, true) }
			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_in(1, false) }
		end

		def test_size
			assert_equal(false, @actor.test_size([0, 1, 2, 3], 3))
			assert_equal(true, @actor.test_size([0, 1, 2, 3], 4))
			assert_equal(false, @actor.test_size([0, 1, 2, 3], 5))

			assert_equal(true, @actor.test_size('test', 4))
			assert_equal(false, @actor.test_size('test', 5))

			assert_equal(true, @actor.test_size({test1: 1, test2: 2}, 2))
			assert_equal(false, @actor.test_size({test1: 1, test2: 2}, 3))

			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_size(true, true) }
		end

		def test_regexp
			assert_equal(true, @actor.test_regexp('This is my test', /\w{2}\s/))
			assert_equal(true, @actor.test_regexp('This is my test', /\w{2}\s/))
			assert_equal(false, @actor.test_regexp('This is my test', /\w{12}/))
			assert_equal(true, @actor.test_regexp('info@example.com', /\w+@\w+\.\w+/))
			assert_equal(false, @actor.test_regexp('infoexample.com', /\w+@\w+\.\w+/))

			assert_equal(true, @actor.test_regexp('This is my test', '\w{2}\s'))
			assert_equal(false, @actor.test_regexp('This is my test', '^\w{2}\s'))
			assert_equal(true, @actor.test_regexp('This is my test', '\w{2}'.to_sym))

			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_regexp('test', true) }
			assert_raises(Screenplay::UnsupportedTypeTestException) { @actor.test_regexp(true, /\d+/) }
		end

		def test_play
			input = {
				callsign: 'husker',
				name: 'William Adama',
				wifes: ['Carolanne Adama'],
				children: ['Zak Adama', 'Lee Adama'],
				service_record: {
					'D6/21311'.to_sym => 'First commission: Battlestar Galactica air group',
					'E4/21312'.to_sym => 'Commendation for shooting down Cylon fighter in first viper combat mission',
					'D5/21314'.to_sym => 'Mustered out of service post-armistice',
					'R6/21317'.to_sym => 'Served as Deck Hand in merchant fleet and as common [...] aboard inter-colony tramp freighters',
					'D1/21331'.to_sym => 'Recommissioned in Colonial Fleet',
					'D6/21337'.to_sym => 'Major: Battlestar Atlantia',
					'R8/21341'.to_sym => 'Executive Officer: Battlestar Columbia',
					'C2/21345'.to_sym => 'Commander: Commanding Officer, Battlestar Valkyrie',
					'C2/21348'.to_sym => 'Commander: Commanding Officer, Battlestar Galactica'
				},
			}

			assert_equal(input, @actor.play({eq: {callsign: 'husker'}}, input))
			assert_equal(input, @actor.play({'not-eq'.to_sym => {callsign: 'starbuck'}}, input))

			assert_raises(TestFailedException) { @actor.play({'not-eq'.to_sym => {callsign: 'husker'}}, input) }

			assert_raises(TestFailedException) { @actor.play({eq: {callsign: 'starbuck'}}, input) }
			assert_raises(UnknownTestException) { @actor.play({invalid: {callsign: 'husker'}}, input) }
			assert_raises(UnsupportedTypeTestException) { @actor.play({regexp: {callsign: true}}, input) }
			assert_equal(input, @actor.play({size: {callsign: 6}}, input))
			assert_raises(TestFailedException) { @actor.play({size: {callsign: 12}}, input) }

			assert_equal(input, @actor.play({in: {callsign: ['starbuck', 'husker']}}, input))
			assert_raises(TestFailedException) { @actor.play({in: {callsign: ['starbuck', 'apollo']}}, input) }

		end

	end

end
