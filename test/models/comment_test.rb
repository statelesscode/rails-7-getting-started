require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = articles(:nerd)
    @comment = comments(:why_visionary)
    @commenter = "A new commenter"
    @valid_body = "I am a comment body"
    @bad_status = "Censored"
    @valid_status = "public"
    @status_inclusion = "Status is not included in the list"
  end

  test "should be valid and creatable with correct attributes" do
    # new
    comment = Comment.new(
      commenter: @commenter,
      body: @valid_body,
      article: @article,
      status: @valid_status
    )
    assert comment.valid?
    assert comment.save
    comment.reload
    assert_not_nil comment.id
    assert_equal @article.id, comment.article_id
    assert_equal @commenter, comment.commenter
    assert_equal @valid_body, comment.body
    assert_equal @valid_status, comment.status

    # existing
    assert @comment.valid?
  end

  test "should be invalid with bad status" do
    # new
    comment = Comment.new(
      commenter: @commenter,
      body: @valid_body,
      article: @article,
      status: @bad_status
    )
    assert_not comment.valid?
    assert_includes comment.errors.full_messages, @status_inclusion

    # existing
    @comment.status = @bad_status
    assert_not @comment.valid?
    assert_includes @comment.errors.full_messages, @status_inclusion
  end

  test "archived should be true if archived" do
    @comment.status = "archived"
    assert @comment.archived?
  end

  test "archived should be false if not archived" do
    assert_not @comment.archived?
    @comment.status = "private"
    assert_not @comment.archived?
  end
end
