require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include VisibleTestHelpers
  include RichTextBodyTestHelpers

  def setup
    @article = articles(:nerd)
    @comment = comments(:why_visionary)
    @commenter = "A new commenter"
    @valid_body = "I am a comment body"
    @commenter_blank = "Commenter can't be blank"
    shared_status_setup
    shared_body_setup
    @status_new = get_new_comment
    @status_existing = @comment
    @public_count = 2
    @klass_name = Comment
  end

  test "has valid fixtures" do
    run_model_fixture_tests @klass_name
  end

  test "should be valid and creatable with correct attributes" do
    comment = get_new_comment
    assert comment.valid?
    assert comment.save
    comment.reload
    assert_not_nil comment.id
    assert_equal @article.id, comment.article_id
    assert_equal @commenter, comment.commenter
    assert_equal @valid_body, comment.body.to_plain_text
    assert_equal @valid_status, comment.status
  end

  test "should be invalid if commenter is blank" do
    # new
    comment = get_new_comment
    comment.commenter = nil
    assert_not comment.valid?
    assert_includes comment.errors.full_messages, @commenter_blank

    # existing with nil
    @comment.commenter = nil
    assert_not @comment.valid?
    assert_includes @comment.errors.full_messages, @commenter_blank
  end

  private
    def get_new_comment
      Comment.new(
        commenter: @commenter,
        body: @valid_body,
        article: @article,
        status: @valid_status
      )
    end
end
