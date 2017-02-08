require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference "Relationship.count" do
      post user_relationships_path user_id: 1
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    user = users :michael
    relationship = relationships :one
    assert_no_difference "Relationship.count" do
      delete user_relationship_path(user_id: user.id, id: relationship.id)
    end
    assert_redirected_to login_url
  end
end
