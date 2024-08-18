module CopyAi
  class Authenticator
    AUTHENTICATION_HEADER = "x-copy-ai-api-key".freeze

    attr_accessor :api_key

    def initialize(api_key:)
      @api_key = api_key
    end

    def header
      {AUTHENTICATION_HEADER => api_key}
    end
  end
end
