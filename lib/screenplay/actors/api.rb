require 'rest_client'
require File.join(File.dirname(__FILE__), '..', 'actor')

module Screenplay

	class WrongResponseCodeException < Exception
		def initialize(expected, actual)
			super("Expected HTTP response code #{expected}, but received #{actual}.")
		end
	end

	class ApiActor < Actor

		attr_reader :cookies

		def configure(config)
			@url = config[:url].to_s
			@url += '/' unless @url.end_with?('/')
			@request_headers = config[:request_headers] || {}
			@cookies = nil
		end

		def play(params, input)
			raise Exception.new('Missing configuration api.url') if @url == '/'
			path = params[:path]
			method = params[:method].downcase.to_sym rescue :get
			expects = (params[:expect] || 200).to_i
			data = params[:data] || {} rescue {}
			data = input if (data.is_a?(String)) && (data == '$input')
			data.stringify_keys!
			headers = @request_headers
			headers[:cookie] = @cookies unless @cookies.nil?
			url = @url + path.to_s.replace_vars(input)
			if ([:get, :head, :delete].include?(method))
				headers[:params] = data
				data = {}
			end

			begin
				response = RestClient::Request.execute({
					url: url,
					method: method,
					headers: headers,
					payload: data
				})
			rescue => e
				response = e.response
			end

			if response.code != expects
				raise WrongResponseCodeException.new(expects, response.code)
			end

			unless response.nil?
				output = JSON.parse(response.body) rescue {}
				@cookies = response.headers[:set_cookie][0] rescue nil
			end

			return output || {}
		end

	end

end