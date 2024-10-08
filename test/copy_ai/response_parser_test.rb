require_relative "../test_helper"

module CopyAi
  class ResponseParserTest < Minitest::Test
    cover ResponseParser

    def setup
      @response_parser = ResponseParser.new
      @uri = URI(TEST_API_ENDPOINT)
    end

    def response(uri = @uri)
      Net::HTTP.get_response(uri)
    end

    def test_success_response
      stub_request(:get, @uri.to_s)
        .to_return(body: '{"message": "success"}', headers: {"Content-Type" => "application/json"})

      assert_equal({"message" => "success"}, @response_parser.parse(response:))
    end

    def test_non_json_success_response
      stub_request(:get, @uri.to_s)
        .to_return(body: "<html></html>", headers: {"Content-Type" => "text/html"})

      assert_nil @response_parser.parse(response:)
    end

    def test_that_it_parses_204_no_content_response
      stub_request(:get, @uri.to_s).to_return(status: 204)

      assert_nil @response_parser.parse(response:)
    end

    def test_bad_request_error
      stub_request(:get, @uri.to_s).to_return(status: 400)
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_kind_of Net::HTTPBadRequest, exception.response
      assert_equal "400", exception.code
    end

    def test_unknown_error_code
      stub_request(:get, @uri.to_s).to_return(status: 418)
      assert_raises(Error) { @response_parser.parse(response:) }
    end

    def test_error_with_title_only
      stub_request(:get, @uri.to_s)
        .to_return(status: [400, "Bad Request"], body: '{"title": "Some Error"}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal "Bad Request", exception.message
    end

    def test_error_with_detail_only
      stub_request(:get, @uri.to_s)
        .to_return(status: [400, "Bad Request"],
          body: '{"detail": "Something went wrong"}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal "Bad Request", exception.message
    end

    def test_error_with_title_and_detail_error_message
      stub_request(:get, @uri.to_s)
        .to_return(status: 400,
          body: '{"title": "Some Error", "detail": "Something went wrong"}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal("Some Error: Something went wrong", exception.message)
    end

    def test_error_with_error_message
      stub_request(:get, @uri.to_s)
        .to_return(status: 400, body: '{"error": "Some Error"}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal("Some Error", exception.message)
    end

    def test_error_with_errors_array_message
      stub_request(:get, @uri.to_s)
        .to_return(status: 400,
          body: '{"errors": [{"message": "Some Error"}, {"message": "Another Error"}]}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal("Some Error, Another Error", exception.message)
    end

    def test_error_with_errors_message
      stub_request(:get, @uri.to_s)
        .to_return(status: 400, body: '{"errors": {"message": "Some Error"}}', headers: {"Content-Type" => "application/json"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_empty exception.message
    end

    def test_non_json_error_response
      stub_request(:get, @uri.to_s)
        .to_return(status: [400, "Bad Request"], body: "<html>Bad Request</html>", headers: {"Content-Type" => "text/html"})
      exception = assert_raises(BadRequest) { @response_parser.parse(response:) }

      assert_equal "Bad Request", exception.message
    end

    def test_default_response_objects
      stub_request(:get, @uri.to_s)
        .to_return(body: '{"array": [1, 2, 2, 3]}', headers: {"Content-Type" => "application/json"})
      hash = @response_parser.parse(response:)

      assert_kind_of Hash, hash
      assert_kind_of Array, hash["array"]
      assert_equal [1, 2, 2, 3], hash["array"]
    end

    def test_custom_response_objects
      stub_request(:get, @uri.to_s)
        .to_return(body: STUB_CLIENT_SUCCESS_GET_RESPONSE, headers: {"Content-Type" => "application/json"})
      body = @response_parser.parse(response:)

      assert_equal JSON.parse(STUB_CLIENT_SUCCESS_GET_RESPONSE), body
    end
  end
end
