require "test_helper"

class EntitiesControllerTest < ActionDispatch::IntegrationTest
  test "should create new entity" do
    id = Sentence.first.id
    post "/sentences/#{id}/entities", text: "foo", typ: "TEST"
    assert_response :success

    assert_not_nil Entity.find_by_typ("TEST")
  end
end
