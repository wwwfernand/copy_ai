require_relative "../test_helper"

module CopyAi
  class AuthenticatorTest < Minitest::Test
    cover Authenticator

    def setup
      @authenticator = Authenticator.new(api_key: TEST_API_KEY)
    end

    def test_initialize
      assert_equal TEST_API_KEY, @authenticator.api_key
    end

    def test_header
      assert_equal @authenticator.header["x-copy-ai-api-key"], TEST_API_KEY
    end
  end
end
