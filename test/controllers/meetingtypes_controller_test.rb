require 'test_helper'

class MeetingtypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meetingtype = meetingtypes(:one)
  end

  test "should get index" do
    get meetingtypes_url
    assert_response :success
  end

  test "should get new" do
    get new_meetingtype_url
    assert_response :success
  end

  test "should create meetingtype" do
    assert_difference('Meetingtype.count') do
      post meetingtypes_url, params: { meetingtype: { name: @meetingtype.name } }
    end

    assert_redirected_to meetingtype_url(Meetingtype.last)
  end

  test "should show meetingtype" do
    get meetingtype_url(@meetingtype)
    assert_response :success
  end

  test "should get edit" do
    get edit_meetingtype_url(@meetingtype)
    assert_response :success
  end

  test "should update meetingtype" do
    patch meetingtype_url(@meetingtype), params: { meetingtype: { name: @meetingtype.name } }
    assert_redirected_to meetingtype_url(@meetingtype)
  end

  test "should destroy meetingtype" do
    assert_difference('Meetingtype.count', -1) do
      delete meetingtype_url(@meetingtype)
    end

    assert_redirected_to meetingtypes_url
  end
end
