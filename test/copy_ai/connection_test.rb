require "net/http"
require "uri"
require_relative "../test_helper"

module CopyAi
  class ConnectionTest < Minitest::Test
    cover Connection

    def setup
      @connection = Connection.new
      @uri = URI(TEST_API_ENDPOINT)
    end

    def test_initialization_defaults
      assert_equal Connection::DEFAULT_OPEN_TIMEOUT, @connection.open_timeout
      assert_equal Connection::DEFAULT_READ_TIMEOUT, @connection.read_timeout
      assert_equal Connection::DEFAULT_WRITE_TIMEOUT, @connection.write_timeout
      assert_equal Connection::DEFAULT_DEBUG_OUTPUT, @connection.debug_output
    end

    def test_custom_initialization
      connection = Connection.new(open_timeout: 10, read_timeout: 20, write_timeout: 30, debug_output: $stderr)

      assert_equal 10, connection.open_timeout
      assert_equal 20, connection.read_timeout
      assert_equal 30, connection.write_timeout
      assert_equal $stderr, connection.debug_output
    end

    def test_http_client_defaults
      http_client = @connection.send(:build_http_client, @uri.host, @uri.port)

      assert_equal @uri.host, http_client.address
      assert_equal @uri.port, http_client.port
      assert_equal Connection::DEFAULT_OPEN_TIMEOUT, http_client.open_timeout
      assert_equal Connection::DEFAULT_READ_TIMEOUT, http_client.read_timeout
      assert_equal Connection::DEFAULT_WRITE_TIMEOUT, http_client.write_timeout
    end

    def test_debug_output
      http_client = @connection.send(:build_http_client, @uri.host, @uri.port)

      assert_equal Connection::DEFAULT_DEBUG_OUTPUT, http_client.instance_variable_get(:@debug_output)
    end

    def test_client_properties
      connection = Connection.new(open_timeout: 10, read_timeout: 20, write_timeout: 30, debug_output: $stderr)
      http_client = connection.send(:build_http_client, @uri.host, @uri.port)

      assert_equal 10, http_client.open_timeout
      assert_equal 20, http_client.read_timeout
      assert_equal 30, http_client.write_timeout
      assert_equal $stderr, http_client.instance_variable_get(:@debug_output)
    end

    def test_valid_perform
      stub_request(:get, TEST_API_ENDPOINT).to_return(body: STUB_CLIENT_SUCCESS_GET_RESPONSE)
      request = Net::HTTP::Get.new(@uri)
      @connection.perform(request:)

      assert_requested :get, TEST_API_ENDPOINT
    end

    def test_invalid_url_api_endpoint_credential
      exception = assert_raises(ArgumentError) { @connection.perform(request: Net::HTTP::Get.new(URI("/123/456/789"))) }

      assert_equal "not an HTTP URI", exception.message
    end

    def test_network_error
      stub_request(:get, TEST_API_ENDPOINT).to_raise(Errno::ECONNREFUSED)
      request = Net::HTTP::Get.new(@uri)
      exception = assert_raises(NetworkError) { @connection.perform(request:) }

      assert_equal "Network error: Connection refused - Exception from WebMock", exception.message
    end
  end
end
