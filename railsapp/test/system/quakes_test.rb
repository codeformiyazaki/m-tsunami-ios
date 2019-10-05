require "application_system_test_case"

class QuakesTest < ApplicationSystemTestCase
  setup do
    @quake = quakes(:one)
  end

  test "visiting the index" do
    visit quakes_url
    assert_selector "h1", text: "Quakes"
  end

  test "creating a Quake" do
    visit quakes_url
    click_on "New Quake"

    fill_in "Device", with: @quake.device_id
    fill_in "Elapsed", with: @quake.elapsed
    fill_in "P", with: @quake.p
    fill_in "S", with: @quake.s
    click_on "Create Quake"

    assert_text "Quake was successfully created"
    click_on "Back"
  end

  test "updating a Quake" do
    visit quakes_url
    click_on "Edit", match: :first

    fill_in "Device", with: @quake.device_id
    fill_in "Elapsed", with: @quake.elapsed
    fill_in "P", with: @quake.p
    fill_in "S", with: @quake.s
    click_on "Update Quake"

    assert_text "Quake was successfully updated"
    click_on "Back"
  end

  test "destroying a Quake" do
    visit quakes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Quake was successfully destroyed"
  end
end
