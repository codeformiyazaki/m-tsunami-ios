require 'test_helper'

class ApnTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @apn_token = apn_tokens(:one)
    ENV["BASIC_AUTH_PASS"] = "secret"
    @basic = {Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('code4miyazaki', 'secret')}
  end

  test "should get index" do
    get apn_tokens_url, headers: @basic
    assert_response :success
  end

  test "should get new" do
    get new_apn_token_url, headers: @basic
    assert_response :success
  end

  test "should create apn_token" do
    # can be posted without authentication.
    assert_difference('ApnToken.count') do
      post apn_tokens_url, params: { apn_token: { token: "token3", type: @apn_token.purpose } }
    end
    assert_redirected_to apn_token_url(ApnToken.last)
    assert_no_changes('ApnToken.count') do
      post apn_tokens_url(:json), params: { apn_token: { token: "token3", type: @apn_token.purpose } }
    end
    assert_response :success
  end

  test "should show apn_token" do
    get apn_token_url(@apn_token), headers: @basic
    assert_response :success
  end

  test "should get edit" do
    get edit_apn_token_url(@apn_token), headers: @basic
    assert_response :success
  end

  test "should update apn_token" do
    patch apn_token_url(@apn_token), params: { apn_token: { token: @apn_token.token, type: @apn_token.purpose } }, headers: @basic
    assert_redirected_to apn_token_url(@apn_token)
  end

  test "should destroy apn_token" do
    assert_difference('ApnToken.count', -1) do
      delete apn_token_url(@apn_token), headers: @basic
    end

    assert_redirected_to apn_tokens_url
  end
end
