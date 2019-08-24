require "application_system_test_case"

class ApnTokensTest < ApplicationSystemTestCase
  setup do
    @apn_token = apn_tokens(:one)
  end

  test "visiting the index" do
    visit apn_tokens_url
    assert_selector "h1", text: "Apn Tokens"
  end

  test "creating a Apn token" do
    visit apn_tokens_url
    click_on "New Apn Token"

    fill_in "Token", with: @apn_token.token
    fill_in "Type", with: @apn_token.type
    click_on "Create Apn token"

    assert_text "Apn token was successfully created"
    click_on "Back"
  end

  test "updating a Apn token" do
    visit apn_tokens_url
    click_on "Edit", match: :first

    fill_in "Token", with: @apn_token.token
    fill_in "Type", with: @apn_token.type
    click_on "Update Apn token"

    assert_text "Apn token was successfully updated"
    click_on "Back"
  end

  test "destroying a Apn token" do
    visit apn_tokens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Apn token was successfully destroyed"
  end
end
