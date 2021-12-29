require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:nerd)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New post"

    fill_in "Body", with: @post.body
    fill_in "Title", with: @post.title
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit this post", match: :first

    fill_in "Body", with: @post.body
    fill_in "Title", with: @post.title
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back"
  end

  test "should destroy Post" do
    visit post_url(@post)
    page.accept_confirm do
      click_on "Destroy this post", match: :first
    end

    assert_text "Post was successfully destroyed"
    assert_text "Posts"
    assert_no_text @post.title
    assert_text posts(:why).title
    assert_text "New post"
  end
end
