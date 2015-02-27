# encoding: utf-8
# The classes in this file extend common datatypes with some extra functionality.

# The Boolean module is used to mixin in the TrueClass and FalseClass for easy comparison.
# This way fields can be given the Boolean datatype instead of a TrueClass or a FalseClass.
module Boolean
end


# Adds the Boolean module into the TrueClass as mixin
class TrueClass
	include Boolean
end


# Adds the Boolean module into the FalseClass as mixin
class FalseClass
	include Boolean
end


# Adds a few extra methods to the standard Hash
class Hash

	# Removes all nil values from the hash. If the value is an array or hash, it will do this recursively.
	def remove_nil_values!
		self.delete_if { |_, v| v.nil? }
		self.each { |_, v| v.remove_nil_values! if (v.is_a?(Hash) || v.is_a?(Array)) }
	end

	# Changes all keys to symbols. If the value is an array or hash, it will do this recursively.
	def symbolize_keys!(recursive = true)
		self.keys.each { | key |
			if !key.is_a?(Symbol)
				val = self.delete(key)
				val.symbolize_keys! if (recursive && (val.is_a?(Hash) || val.is_a?(Array)))
				self[(key.to_sym rescue key) || key] = val
			end
			self[key.to_sym].symbolize_keys! if (recursive && (self[key.to_sym].is_a?(Hash) || self[key.to_sym].is_a?(Array)))
		}
		return self
	end

	# Changes all keys to strings.  If the value is an array or hash, it will do this recursively.
	def stringify_keys!(recursive = true)
		self.keys.each do |key|
			if !key.is_a?(String)
				val = self.delete(key)
				val.stringify_keys! if (recursive && (val.is_a?(Hash) || val.is_a?(Array)))
				self[(key.to_s rescue key) || key] = val
			end
		end
		return self
	end

end


# Adds a few extra methods to the standard Hash
class Array

	# Removes all nil values from the hash. If the value is an array or hash, it will do this recursively.
	def remove_nil_values!
		self.compact!
		self.each { |val| val.remove_nil_values! if (val.is_a?(Hash) || val.is_a?(Array)) }
	end

	# Changes all keys to symbols. If the value is an array or hash, it will do this recursively.
	def symbolize_keys!(recursive = true)
		self.map! { |val| val.symbolize_keys! if (recursive && (val.is_a?(Hash) || val.is_a?(Array))); val }
	end

	# Changes all keys to strings. If the value is an array or hash, it will do this recursively.
	def stringify_keys!(recursive = true)
		self.map! { |val| val.stringify_keys! if (recursive && (val.is_a?(Hash) || val.is_a?(Array))); val }
	end

end


# Adds a few extra methods to the standard String
class String

	# Returns true if a string is numeric.
	def numeric?
		self.to_i.to_s == self
	end

	# Strips single or double quotes at the start and end of the given string.
	def strip_quotes
		gsub(/\A['"]+|['"]+\Z/, '')
	end

	# Normalizes a string, remove diacritics (accents)
	def normalize
		tr(
			"ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
			"AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
	end

	def truncate(max_length, ellipses = '...')
		(self.length > max_length) ? self.to_s[0..max_length].gsub(/[^\w]\w+\s*$/, '...') : self.to_s
	end

	def replace_vars!(input)
		input = {} unless input.is_a?(Hash)
		return if input.empty?
		matches = {}
		input.each { | k, v | matches['#{' + k.to_s + '}'] = v.to_s }
		self.gsub!(/\#({\w+})/, matches)
	end

	def replace_vars(input)
		result = self.dup
		result.replace_vars!(input)
		return result
	end

	def snake_case
		self.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr('-', '_').downcase
	end

	def camel_case
		self.split('_').collect(&:capitalize).join
	end

end