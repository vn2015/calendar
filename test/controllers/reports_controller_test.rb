require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get weekly_activity" do
    get reports_weekly_activity_url
    assert_response :success
  end

end
