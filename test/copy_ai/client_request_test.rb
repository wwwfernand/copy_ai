require_relative "../test_helper"

module CopyAi
  class ClientRequestTest < Minitest::Test
    cover Client

    def setup
      @client = Client.new(**test_api_credentials)
    end

    define_method :test_get_request do
      stub_request(:get, TEST_API_ENDPOINT)

      assert_requested :get, TEST_API_ENDPOINT
    end

    define_method :test_post_request do
      stub_request(:post, TEST_API_ENDPOINT)

      assert_requested :post, TEST_API_ENDPOINT
    end
  end
end
