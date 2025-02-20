require_relative 'test_helper'

class HelloWorldTest < Minitest::Test

  def test_homepage_returns_hello_world
    get '/' # Simulate GET request to `/`
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    assert_equal({ message: "Hello, World!" }.to_json, last_response.body)
  end
end
