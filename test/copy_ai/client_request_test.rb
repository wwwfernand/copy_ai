require_relative "../test_helper"

module CopyAi
  class ClientRequestTest < Minitest::Test
    cover Client

    def setup
      @client = Client.new(**test_api_credentials)
    end

    define_method :test_get_request do
      stub_request(:get, TEST_API_ENDPOINT)
      @client.get

      assert_requested(:get, TEST_API_ENDPOINT, times: 1) { |req| req.body.nil? }
    end

    define_method :test_post_nil_request do
      stub_request(:post, TEST_API_ENDPOINT)
      @client.post(body: nil)

      assert_requested(:post, TEST_API_ENDPOINT, times: 1)
    end

    define_method :test_post_data_request do
      stub_request(:post, TEST_API_ENDPOINT)
      @client.post(body: {data: 1})

      assert_requested(:post, TEST_API_ENDPOINT, times: 1) { |req| req.body == {data: 1}.to_json }
    end
  end
end
