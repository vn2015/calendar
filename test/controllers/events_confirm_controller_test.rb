require 'test_helper'

class EventsConfirmControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_confirm_index_url
    assert_response :success
  end

end
