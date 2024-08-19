require "uri"
require_relative "../test_helper"

module CopyAi
  class RequestBuilderTest < Minitest::Test
    cover RequestBuilder

    def setup
      @authenticator = Authenticator.new(api_key: TEST_API_KEY)
      @request_builder = RequestBuilder.new
      @uri = URI(TEST_API_ENDPOINT)
    end

    def test_build_get_request
      request = @request_builder.build(http_method: :get, uri: @uri, authenticator: @authenticator, body: nil)

      assert_equal "GET", request.method
      assert_equal @uri, request.uri
      assert_equal TEST_API_KEY, request[Authenticator::AUTHENTICATION_HEADER]
      assert_equal "application/json", request["Content-Type"]
    end

    def test_build_existing_header
      request = @request_builder.build(http_method: :get, uri: @uri, authenticator: @authenticator, body: nil)

      assert_equal "GET", request.method
      assert_equal @uri, request.uri
      assert_equal TEST_API_KEY, request[Authenticator::AUTHENTICATION_HEADER]
      assert_equal "application/json", request["Content-Type"]
    end

    def test_build_post_empty_body_request
      request = @request_builder.build(http_method: :post, uri: @uri, body: {}, authenticator: @authenticator)

      assert_equal "POST", request.method
      assert_equal @uri, request.uri
      assert_equal "{}", request.body
      assert_equal TEST_API_KEY, request[Authenticator::AUTHENTICATION_HEADER]
    end

    def test_build_post_nil_body_request
      request = @request_builder.build(http_method: :post, uri: @uri, body: nil, authenticator: @authenticator)

      assert_equal "POST", request.method
      assert_equal @uri, request.uri
      assert_nil request.body
      assert_equal TEST_API_KEY, request[Authenticator::AUTHENTICATION_HEADER]
    end

    def test_build_post_with_data_body_request
      request = @request_builder.build(http_method: :post, uri: @uri, body: {res: 1}, authenticator: @authenticator)

      assert_equal "POST", request.method
      assert_equal @uri, request.uri
      assert_equal TEST_API_KEY, request[Authenticator::AUTHENTICATION_HEADER]
    end

    def test_build_without_authenticator_parameter
      exception = assert_raises ArgumentError do
        @request_builder.build(http_method: :get, authenticator: nil, uri: @uri, body: nil)
      end

      assert_equal "Missing Credentials", exception.message
    end

    def test_unsupported_http_method
      exception = assert_raises ArgumentError do
        @request_builder.build(http_method: :unsupported, uri: @uri, authenticator: @authenticator, body: nil)
      end

      assert_equal "Unsupported HTTP method: unsupported", exception.message
    end
  end
end
