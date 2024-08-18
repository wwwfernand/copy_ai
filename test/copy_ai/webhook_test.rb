require_relative "../test_helper"
require_relative "../../lib/copy_ai/webhook"

module CopyAi
  class WebhookTest < Minitest::Test
    cover Webhook

    def setup
      @client = Client.new(**test_api_credentials)
      @url = "https://test.com/webhook"
    end

    def test_register
      stub_request(:post, Webhook::WEBHOOK_URL).to_return(body: STUB_WEBHOOK_SUCCESS_RESPONSE,
        headers: {"Content-Type" => "application/json"})
      response = Webhook.register(@client, url: @url, event_type: Webhook::EVENT_TYPES.first)

      assert_equal(JSON.parse(STUB_WEBHOOK_SUCCESS_RESPONSE), response)
    end

    def test_invalid_event_type
      exception = assert_raises ArgumentError do
        Webhook.register(@client, url: @url, event_type: "unsupported")
      end

      assert_equal "Invalid event_type: unsupported", exception.message
    end
  end
end
