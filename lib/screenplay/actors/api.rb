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
			http_params = params[:params] || {} rescue {}
			http_params = input if (http_params.is_a?(String)) && (http_params == '$input')
			http_params.stringify_keys!
			headers = @request_headers
			headers[:cookie] = @cookies unless @cookies.nil?

			begin
				response = RestClient::Request.execute({
					url: @url + path.to_s.replace_vars(input),
					method: method,
					headers: headers,
					payload: http_params
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