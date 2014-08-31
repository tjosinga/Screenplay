require File.join(File.dirname(__FILE__), '..', 'actor')

module Screenplay

	class TestFailedException < Exception
		def initialize(test, a, b)
			super("#{test} on #{a.to_s} failed. Expected: #{b.to_s}.")
		end
	end

	class UnknownTestException < Exception
		def initialize(test)
			super("Unknown test #{test}")
		end
	end

	class UnsupportedTypeTestException < Exception
		def initialize(test, a)
			super("Unsupported data type for test #{test}: #{a.to_s}")
		end
	end

	class UnknownInputKeyException < Exception
		def initialize(test, key)
			super("Couldn't find #{key} in the input for test #{test}.")
		end
	end

	class TestActor < Actor

		def play(params, input)
			params.each { | key, values |
				values.each { | test, b |
					expects = !test.to_s.start_with?('not-')
					test = test.to_s[4..-1] unless expects
					method = "test_#{test}".to_sym
					raise UnknownTestException.new(test) if !respond_to?(method)
					raise UnknownInputKeyException.new(test, key) unless input.include?(key.to_sym)
					a = input[key.to_sym]
					raise TestFailedException.new(test, a, b) unless (public_send(method, a, b) == expects)
				}
			}
			return input
		end

		def test_lt(a, b)
			a < b
		end

		def test_lte(a, b)
			a <= b
		end

		def test_eq(a, b)
			a === b
		end

		def test_gte(a, b)
			a >= b
		end

		def test_gt(a, b)
			a > b
		end

		def test_in(a, b)
			if (b.is_a?(String))
				b.index(a) != nil
			elsif (b.is_a?(Array))
				b.to_a.include?(a)
			elsif (b.is_a?(Hash))
				b.include?(a.to_sym)
			else
				raise UnsupportedTypeTestException.new(:in, b)
			end
		end

		def test_size(a, b)
			if (a.respond_to?(:size))
				a.size == b
			else
				raise UnsupportedTypeTestException.new(:size, a)
			end
		end

		def test_regexp(a, b)
			b = Regexp.new(b.to_s) if b.is_a?(String) || b.is_a?(Symbol)
			raise UnsupportedTypeTestException.new(:regexp, b) unless b.is_a?(Regexp)
			raise UnsupportedTypeTestException.new(:regexp, a) unless a.is_a?(String)
			!a.match(b).nil?
		end
	end

end