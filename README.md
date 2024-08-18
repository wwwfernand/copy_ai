# A [Ruby](https://www.ruby-lang.org) interface to the [Copy.ai Workflows API](https://docs.copy.ai/docs/getting-started)

## Installation

Install the gem and add to the application's Gemfile:

    bundle add copy_ai

Or, to install directly:

    gem install copy_ai

## Usage

First, obtain credentials from <https://docs.copy.ai/reference/authentication>.

```ruby
require "copy_ai"

copy_ai_credentials = {
  api_key:              "INSERT YOUR X API KEY HERE",
  api_endpoint:         "INSERT YOUR X API ENDPOINT HERE"
}

# Initialize a API client with your Workspace Api Key
copy_ai_client = CopyAi::Client.new(**copy_ai_credentials)

# Register webhook
# url: your site webhook URL
# event_type: https://docs.copy.ai/reference/register-webhook#event-types
ads_client = CopyAi::Webook.register(copy_ai_client, url: 'https://cloud-asm.com/webhook', event_type: 'workflowRun.completed')

# Starting a Workflow Run
post = copy_ai_client.post({
  startVariables: {
	  "Input 1": "<Inputs vary depending on the workflow used.>",
	  "Input 2": "<The best way to see an example is to try it!>"
	},
	"metadata": {
    "api": true
	}
})
# { "status": "success", "data": { "id": "<run_id>" } }

# Tracking / Poll for Progress
copy_ai_client.get
# {
    "status": "success",
    "data":
    {
      "id": "<run_id>",
      "input":
      { 
        "Input 1": "Inputs vary depending on the workflow used.",
        "Input 2": "The best way to see an example is to try it!" 
      },
      "status": "PROCESSING",
      "output":
      {
        "Output 1": "<Outputs vary depending on the workflow used.>",
        "Output 2": "<The best way to see an example is to try it!>"
      },
      "createdAt": "2022-11-18T20:30:07.434Z"
    }
  }

# Run Completion
# When the run is complete, the status will change to COMPLETE and a POST request will be sent to the registered webhooks to notify of the workflow's completion.
# {
    "type": "workflowRun.completed",
    "workflowRunId": "<run_id>",
    "workflowId": "<workflow_id>",
    "result":
    {
      "Output 1": "<Outputs vary depending on the workflow used.>",
      "Output 2": "<The best way to see an example is to try it!>"
    },
    "metadata":
    {
      /* any metadata set on the workflow run */
    },
    "credits": 2 
  }
```

## Development

1. Checkout and repo:

       git checkout git@github.com:wwwfernand/copy_ai.git

2. Enter the repo's directory:

       cd copy_ai

3. Install dependencies via Bundler:

       bundle install

4. Run the default Rake task to ensure all tests pass:

       bundle exec rake

5. Create a new branch for your feature or bug fix:

       git checkout -b my-new-branch

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wwwfernand/copy_ai.

Pull requests will only be accepted if they meet all the following criteria:

1. Code must conform to [Standard Ruby](https://github.com/standardrb/standard#readme).

       bundle exec rake standard

2. Code must conform to the [RuboCop rules](https://github.com/rubocop/rubocop#readme).

       bundle exec rake rubocop

3. 100% C0 code coverage.

       bundle exec rake test

4. 100% mutation coverage.

       bundle exec rake mutant

5. RBS type signatures (in `sig/copy_ai.rbs`).

       bundle exec rake steep

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
