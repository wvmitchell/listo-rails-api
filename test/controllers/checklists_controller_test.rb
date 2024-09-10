require "test_helper"

class ChecklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a fixture for users
    @user2 = users(:two)
    @owned_checklists = [ checklists(:checklist_one) ]
    @shared_checklists = [ checklists(:checklist_two) ]

    @shared_checklists.each { |checklist| checklist.collaborators << @user }

    # sign_in @user # Assuming you have a method to sign in users
  end

  test "should get index" do
    get checklists_url, as: :json
    assert_response :success
  end

  test "should return owned checklists" do
    get checklists_url, as: :json
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["checklists"].size
    assert_equal @owned_checklists.map(&:id).sort,
                 json_response["checklists"].map { |c| c["id"] }.sort
  end

  test "should return shared checklists" do
    get checklists_url, as: :json
    json_response = JSON.parse(response.body)
    assert_equal 2, json_response["shared_checklists"].size
    assert_equal @shared_checklists.map(&:id).sort,
                 json_response["shared_checklists"].map { |c| c["id"] }.sort
  end

  test "should include collaborators in shared checklists" do
    get checklists_url, as: :json
    json_response = JSON.parse(response.body)
    shared_checklist = json_response["shared_checklists"].first
    assert_includes shared_checklist.keys, "collaborators"
  end
end
