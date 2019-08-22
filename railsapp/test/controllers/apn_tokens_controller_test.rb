require 'test_helper'

class ApnTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @apn_token = apn_tokens(:one)
  end

  test "should get index" do
    get apn_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_apn_token_url
    assert_response :success
  end

  test "should create apn_token" do
    assert_difference('ApnToken.count') do
      post apn_tokens_url, params: { apn_token: { token: @apn_token.token, type: @apn_token.type } }
    end

    assert_redirected_to apn_token_url(ApnToken.last)
  end

  test "should show apn_token" do
    get apn_token_url(@apn_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_apn_token_url(@apn_token)
    assert_response :success
  end

  test "should update apn_token" do
    patch apn_token_url(@apn_token), params: { apn_token: { token: @apn_token.token, type: @apn_token.type } }
    assert_redirected_to apn_token_url(@apn_token)
  end

  test "should destroy apn_token" do
    assert_difference('ApnToken.count', -1) do
      delete apn_token_url(@apn_token)
    end

    assert_redirected_to apn_tokens_url
  end
end
