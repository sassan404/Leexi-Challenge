require_relative 'test_helper'

class HomeTest < Minitest::Test

  def test_homepage_returns_hello_world
    get '/' # Simulate GET request to `/`
    assert last_response.ok?
    assert_equal "text/html;charset=utf-8", last_response.content_type
    assert_includes last_response.body, "<title>Leexi Challenge</title>"
  end
end
