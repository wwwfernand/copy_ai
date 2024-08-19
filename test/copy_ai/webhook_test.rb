require_relative "../test_helper"
require_relative "../../lib/copy_ai/webhook"

module CopyAi
  class WebhookTest < Minitest::Test
    cover Webhook

    def setup
      @client = Client.new(**test_api_credentials)
      @url = "https://test.com/webhook"
    end

    def test_register_include_workflow_id
      stub_request(:post, Webhook::WEBHOOK_URL).to_return(body: STUB_WEBHOOK_SUCCESS_RESPONSE,
        headers: {"Content-Type" => "application/json"})
      response = Webhook.register(@client, url: @url, event_type: Webhook::EVENT_TYPES.first, workflow_id: 1)

      assert_equal(@client.api_endpoint, TEST_API_ENDPOINT)
      assert_requested(:post, Webhook::WEBHOOK_URL) do |req|
        req.body == '{"url":"https://test.com/webhook","eventType":"workflowRun.started","workflowId":1}'
      end
      assert_equal(JSON.parse(STUB_WEBHOOK_SUCCESS_RESPONSE), response)
    end

    def test_register_exclude_workflow_id
      stub_request(:post, Webhook::WEBHOOK_URL).to_return(body: STUB_WEBHOOK_SUCCESS_RESPONSE,
        headers: {"Content-Type" => "application/json"})
      response = Webhook.register(@client, url: @url, event_type: Webhook::EVENT_TYPES.first)

      assert_equal(@client.api_endpoint, TEST_API_ENDPOINT)
      assert_requested(:post, Webhook::WEBHOOK_URL)
      assert_equal(JSON.parse(STUB_WEBHOOK_SUCCESS_RESPONSE), response)
    end

    def test_nil_client_argument_error
      exception = assert_raises ArgumentError do
        Webhook.register(nil, url: "https://abc", event_type: "workflowRun.started", workflow_id: 1)
      end

      assert_equal "Missing Arguments", exception.message
    end

    def test_nil_url_argument_error
      exception = assert_raises ArgumentError do
        Webhook.register(@client, url: nil, event_type: "workflowRun.started", workflow_id: 1)
      end

      assert_equal "Missing Arguments", exception.message
    end

    def test_nil_event_type_argument_error
      exception = assert_raises ArgumentError do
        Webhook.register(@client, url: "https://example.com/webhook", event_type: nil)
      end

      assert_equal "Missing Arguments", exception.message
    end

    def test_nil_all_argument_error
      exception = assert_raises ArgumentError do
        Webhook.register(@client, url: nil, event_type: nil)
      end

      assert_equal "Missing Arguments", exception.message
    end

    def test_invalid_event_type
      exception = assert_raises ArgumentError do
        Webhook.register(@client, url: @url, event_type: "unsupported")
      end

      assert_equal "Invalid event_type: unsupported", exception.message
    end
  end
end
