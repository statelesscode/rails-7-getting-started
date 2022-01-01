require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include VisibleTestHelpers

  def setup
    @article = articles(:nerd)
    @comment = comments(:why_visionary)
    @commenter = "A new commenter"
    @valid_body = "I am a comment body"
    shared_status_setup
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
    assert_equal @valid_body, comment.body
    assert_equal @valid_status, comment.status
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
