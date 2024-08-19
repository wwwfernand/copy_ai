require "net/http"
require "uri"
require_relative "authenticator"
require_relative "version"

module CopyAi
  class RequestBuilder
    DEFAULT_HEADERS = {"Content-Type" => "application/json"}.freeze
    HTTP_METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post
    }.freeze

    def build(http_method:, uri:, authenticator:, body:)
      raise ArgumentError, "Missing Credentials" unless authenticator

      request = create_request(http_method:, uri:, body:)
      add_headers(request:, header: authenticator.header)
      request
    end

    private

    def create_request(http_method:, uri:, body:)
      http_method_class = HTTP_METHODS[http_method]

      raise ArgumentError, "Unsupported HTTP method: #{http_method}" unless http_method_class

      request = http_method_class.new(uri)
      request.body = body.to_json unless body.nil?
      request
    end

    def add_headers(request:, header:)
      DEFAULT_HEADERS.merge(header).each do |key, value|
        request.add_field(key, value)
      end
    end
  end
end
