require 'test_helper'

class QuakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quake = quakes(:one)
  end

  test "should get index" do
    get quakes_url
    assert_response :success
  end

  test "should get new" do
    get new_quake_url
    assert_response :success
  end

  test "should create quake" do
    assert_difference('Quake.count') do
      post quakes_url, params: { quake: { device_id: @quake.device_id, elapsed: @quake.elapsed, p: @quake.p, s: @quake.s } }
    end

    assert_redirected_to quake_url(Quake.last)
  end

  test "should show quake" do
    get quake_url(@quake)
    assert_response :success
  end

  test "should get edit" do
    get edit_quake_url(@quake)
    assert_response :success
  end

  test "should update quake" do
    patch quake_url(@quake), params: { quake: { device_id: @quake.device_id, elapsed: @quake.elapsed, p: @quake.p, s: @quake.s } }
    assert_redirected_to quake_url(@quake)
  end

  test "should destroy quake" do
    assert_difference('Quake.count', -1) do
      delete quake_url(@quake)
    end

    assert_redirected_to quakes_url
  end
end
