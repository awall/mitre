require "test_helper"

class SentencesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/sentences"
    assert_response :success
  end

  test "should get show" do
    id = Sentence.first.id
    get "/sentences/#{id}"
    assert_response :success
  end
end
