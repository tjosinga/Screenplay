$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/autorun'
require 'screenplay/datatype-extensions'

class StringRepaceVarsTester < MiniTest::Unit::TestCase

	def test_replace_vars
		input = { id: 'husker', name: 'William Adama' }

		assert_equal('character/husker', 'character/#{id}'.replace_vars(input))
		assert_equal('husker: William Adama', '#{id}: #{name}'.replace_vars(input))

		input = { id: 'husker', name: ['William Adama'] }
		assert_equal('husker: ["William Adama"]', '#{id}: #{name}'.replace_vars(input))

	end

end
