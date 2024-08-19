module CopyAi
  module Webhook
    extend self
    EVENT_TYPES = [
      "workflowRun.started",
      "workflowRun.completed",
      "workflowRun.failed",
      "workflowCreditLimit.reached"
    ].freeze
    WEBHOOK_URL = "https://api.copy.ai/api/webhook".freeze

    # If a workflow ID is not included, events for all workflows in your workspace will be received
    def register(client, url:, event_type:, workflow_id: nil)
      raise ArgumentError, "Missing Arguments" if client.nil? || url.nil? || event_type.nil?

      validate!(event_type:)
      webhook_client = client.dup.tap { |c| c.api_endpoint = WEBHOOK_URL }
      body = {url:, eventType: event_type, workflowId: workflow_id}
      webhook_client.post(body:)
    end

    private

    def validate!(event_type:)
      return if EVENT_TYPES.include?(event_type)

      raise ArgumentError, "Invalid event_type: #{event_type}"
    end
  end
end
