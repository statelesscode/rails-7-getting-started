require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:nerd)
    @valid_title = "I have a valid title"
    @valid_body = "This body is long enough."
    @title_blank = "Title can't be blank"
    @body_blank = "Body can't be blank"
    @body_short = "Body is too short (minimum is 10 characters)"
  end

  test "should be valid and creatable with correct attributes" do
    # new
    post = Post.new(title: @valid_title, body: @valid_body)
    assert post.valid?
    assert post.save
    post.reload
    assert_not_nil post.id
    assert_equal @valid_title, post.title
    assert_equal @valid_body, post.body

    # existing
    assert @post.valid?
  end

  test "should be invalid if title is blank" do
    # new
    post = Post.new(body: @valid_body)
    assert_not post.valid?
    assert_includes post.errors.full_messages, @title_blank

    # existing with nil
    @post.title = nil
    assert_not @post.valid?
    assert_includes @post.errors.full_messages, @title_blank
  end

  test "should be invalid if body is blank" do
    # new
    post = Post.new(title: @valid_title)
    assert_not post.valid?
    assert_includes post.errors.full_messages, @body_blank

    # existing with empty string
    @post.body = ""
    assert_not @post.valid?
    assert_includes @post.errors.full_messages, @body_blank
  end

  test "should be invalid if body is too short" do
    too_short = "Fail"
    # new
    post = Post.new(title: @valid_title, body: too_short)
    assert_not post.valid?
    assert_includes post.errors.full_messages, @body_short

    # existing
    @post.body = too_short
    assert_not @post.valid?
    assert_includes @post.errors.full_messages, @body_short
  end
end
