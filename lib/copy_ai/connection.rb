require "forwardable"
require "net/http"
require "openssl"
require "uri"
require_relative "errors/network_error"

module CopyAi
  class Connection
    extend Forwardable

    DEFAULT_OPEN_TIMEOUT = 60 # seconds
    DEFAULT_READ_TIMEOUT = 60 # seconds
    DEFAULT_WRITE_TIMEOUT = 60 # seconds
    DEFAULT_DEBUG_OUTPUT = File.open(File::NULL, "w")
    NETWORK_ERRORS = [
      Errno::ECONNREFUSED,
      Errno::ECONNRESET,
      Net::OpenTimeout,
      Net::ReadTimeout,
      OpenSSL::SSL::SSLError
    ].freeze

    attr_accessor :open_timeout, :read_timeout, :write_timeout, :debug_output

    def initialize(open_timeout: DEFAULT_OPEN_TIMEOUT, read_timeout: DEFAULT_READ_TIMEOUT,
      write_timeout: DEFAULT_WRITE_TIMEOUT, debug_output: DEFAULT_DEBUG_OUTPUT)
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @debug_output = debug_output
    end

    def perform(request:)
      http_client = build_http_client(request.uri.host, request.uri.port)
      http_client.use_ssl = true
      http_client.request(request)
    rescue *NETWORK_ERRORS => e
      raise NetworkError, "Network error: #{e}"
    end

    private

    def build_http_client(host, port)
      http_client = Net::HTTP.new(host, port)
      configure_http_client(http_client)
    end

    def configure_http_client(http_client)
      http_client.tap do |c|
        c.open_timeout = open_timeout
        c.read_timeout = read_timeout
        c.write_timeout = write_timeout
        c.set_debug_output(debug_output)
      end
    end
  end
end
