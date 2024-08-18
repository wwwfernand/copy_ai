require "forwardable"
require_relative "authenticator"
require_relative "connection"
require_relative "request_builder"
require_relative "response_parser"

module CopyAi
  class Client
    extend Forwardable

    attr_reader :api_key, :api_endpoint, :workflow_id

    def_delegators :@connection, :open_timeout, :read_timeout, :write_timeout, :debug_output
    def_delegators :@connection, :open_timeout=, :read_timeout=, :write_timeout=, :debug_output=

    def initialize(api_key:, api_endpoint:,
      open_timeout: Connection::DEFAULT_OPEN_TIMEOUT,
      read_timeout: Connection::DEFAULT_READ_TIMEOUT,
      write_timeout: Connection::DEFAULT_WRITE_TIMEOUT,
      debug_output: Connection::DEFAULT_DEBUG_OUTPUT)

      @api_key = api_key
      @api_endpoint = api_endpoint
      initialize_authenticator
      initialize_workflow_id
      @connection = Connection.new(open_timeout:, read_timeout:, write_timeout:, debug_output:)
      @request_builder = RequestBuilder.new
      @response_parser = ResponseParser.new
    end

    def get
      execute_request(:get)
    end

    def post(body:)
      execute_request(:post, body:)
    end

    def api_key=(api_key)
      raise ArgumentError, "Missing Credentials" if api_key.nil? || api_key.empty?

      @api_key = api_key
      initialize_authenticator
    end

    def api_endpoint=(api_endpoint)
      raise ArgumentError, "Missing Credentials" if api_endpoint.nil? || api_endpoint.empty?

      @api_endpoint = api_endpoint
      initialize_workflow_id
    end

    private

    def initialize_workflow_id
      @workflow_id = api_endpoint.split("/")[-2]
    end

    def initialize_authenticator
      raise ArgumentError, "Missing Credentials" if api_key.nil? || api_key.empty?

      @authenticator = Authenticator.new(api_key:)
    end

    def execute_request(http_method, body: nil)
      raise ArgumentError, "Missing Credentials" if api_endpoint.nil? || api_endpoint.empty?

      uri = URI(api_endpoint)
      request = @request_builder.build(http_method:, uri:, body:, authenticator: @authenticator)
      response = @connection.perform(request:)
      @response_parser.parse(response:)
    end
  end
end
