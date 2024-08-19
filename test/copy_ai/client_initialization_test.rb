require_relative "../test_helper"

module CopyAi
  class ClientInitializationTest < Minitest::Test
    cover Client

    def setup
      @client = Client.new(**test_api_credentials)
    end

    def test_initialize_api_credentials
      authenticator = @client.instance_variable_get(:@authenticator)

      assert_instance_of Authenticator, authenticator
      assert_equal TEST_API_KEY, authenticator.api_key
    end

    def test_missing_api_key_credential
      exception = assert_raises(ArgumentError) { Client.new(api_key: "", api_endpoint: TEST_API_ENDPOINT) }

      assert_equal "Missing Credentials", exception.message
    end

    def test_nil_api_key_credential
      exception = assert_raises(ArgumentError) { Client.new(api_key: nil, api_endpoint: TEST_API_ENDPOINT) }

      assert_equal "Missing Credentials", exception.message
    end

    def test_missing_api_endpoint_credential
      exception = assert_raises(ArgumentError) { Client.new(api_key: TEST_API_KEY, api_endpoint: "") }

      assert_equal "Missing Credentials", exception.message
    end

    def test_nil_api_endpoint_credential
      exception = assert_raises(ArgumentError) { Client.new(api_key: TEST_API_KEY, api_endpoint: nil) }

      assert_equal "Missing Credentials", exception.message
    end

    def test_invalid_api_endpoint_credential
      exception = assert_raises(ArgumentError) { Client.new(api_key: TEST_API_KEY, api_endpoint: "wrong-endpoint") }

      assert_equal "Invalid Credentials", exception.message
    end

    def test_setting_api_key_reinitializes_authenticator
      @client.api_key = "new-api-key"

      authenticator = @client.instance_variable_get(:@authenticator)

      assert_equal "new-api-key", authenticator.header[Authenticator::AUTHENTICATION_HEADER]
    end

    def test_api_key_nil_error_response
      exception = assert_raises(ArgumentError) { @client.api_key = nil }

      assert_equal "Missing Credentials", exception.message
    end

    def test_api_key_empty_error_response
      exception = assert_raises(ArgumentError) { @client.api_key = "" }

      assert_equal "Missing Credentials", exception.message
    end

    def test_api_endpoint_nil_error_response
      exception = assert_raises(ArgumentError) { @client.api_endpoint = nil }

      assert_equal "Missing Credentials", exception.message
    end

    def test_api_endpoint_empty_error_response
      exception = assert_raises(ArgumentError) { @client.api_endpoint = "" }

      assert_equal "Missing Credentials", exception.message
    end

    def test_api_endpoint_invalid_error_response
      exception = assert_raises(ArgumentError) { @client.api_endpoint = "wrong-endpoint" }

      assert_equal "Invalid Credentials", exception.message
    end

    def test_initialize_with_default_connection_options
      connection = @client.instance_variable_get(:@connection)

      assert_equal Connection::DEFAULT_OPEN_TIMEOUT, connection.open_timeout
      assert_equal Connection::DEFAULT_READ_TIMEOUT, connection.read_timeout
      assert_equal Connection::DEFAULT_WRITE_TIMEOUT, connection.write_timeout
      assert_equal Connection::DEFAULT_DEBUG_OUTPUT, connection.debug_output
    end

    def test_initialize_connection_options
      client = Client.new(api_key: TEST_API_KEY, api_endpoint: TEST_API_ENDPOINT,
        open_timeout: 10, read_timeout: 20, write_timeout: 30, debug_output: $stderr)

      connection = client.instance_variable_get(:@connection)

      assert_equal 10, connection.open_timeout
      assert_equal 20, connection.read_timeout
      assert_equal 30, connection.write_timeout
      assert_equal $stderr, connection.debug_output
    end

    def test_update_api_key
      @client.api_key = "new-api-key"
      @client.api_endpoint = "https://test.com/api/workflow/new-workflow-id/run"

      assert_equal "new-api-key", @client.api_key
      assert_equal "https://test.com/api/workflow/new-workflow-id/run", @client.api_endpoint
      assert_equal "new-workflow-id", @client.workflow_id
    end
  end
end
