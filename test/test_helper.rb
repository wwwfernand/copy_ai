$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

unless $PROGRAM_NAME.end_with?("mutant")
  require "simplecov"
  require "simplecov_json_formatter"

  SimpleCov.start do
    add_filter "test"
    formatter SimpleCov::Formatter::JSONFormatter if ENV["GITHUB_ACTIONS"]
    minimum_coverage(100)
  end
end

require "minitest/autorun"
require "mutant/minitest/coverage"
require "webmock/minitest"
require "copy_ai"

TEST_API_KEY = "TEST-API-KEY".freeze
TEST_WORKFLOW_ID = "PKGW-4cb07d3b-57c4-475c-8bf1-e70759290e62".freeze
TEST_API_ENDPOINT = "https://api.copy.ai/api/workflow/#{TEST_WORKFLOW_ID}/run".freeze
STUB_WEBHOOK_SUCCESS_RESPONSE = {
  status: "success",
  data: {
    id: "webhook-id",
    url: "https://mywebsite.com/webhook",
    eventType: "workflowRun.completed",
    workflowId: "workflow-id"
  }
}.to_json
STUB_CLIENT_SUCCESS_GET_RESPONSE = {
  status: "success",
  data:
  {
    id: "run-id>",
    input:
      {
        "Input 1": "input-01",
        "Input 2": "input-02"
      },
    status: "PROCESSING",
    output:
      {
        "Output 1": "output-01",
        "Output 2": "output-02"
      },
    createdAt: "2022-11-18T20:30:07.434Z"
  }
}.to_json
STUB_CLIENT_SUCCESS_POST_RESPONSE = {
  status: "success",
  data: {
    id: "run-id"
  }
}.to_json

def test_api_credentials
  {
    api_key: TEST_API_KEY,
    api_endpoint: TEST_API_ENDPOINT
  }
end
