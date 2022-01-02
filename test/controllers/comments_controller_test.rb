require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @article = articles(:nerd)
    @valid_status = "public"
    @auth_headers = generate_auth_headers
  end

  test "should create comment" do
    commenter = "A new commenter"
    body = "This is my comment on the Nerd Dice article."
    assert_difference("Comment.count") do
      post article_comments_url(@article), params: {
        article_id: @article.id,
        comment: {
          commenter: commenter,
          body: body,
          status: @valid_status
        }
      }
    end

    comment = @article.comments.last
    assert_redirected_to article_path(@article)
    assert_equal commenter, comment.commenter
    assert_equal body, comment.body
    assert_equal "Comment was successfully created.", flash[:notice]
  end

  test "should destroy comment" do
    comment = @article.comments.last
    assert_difference("Comment.count", -1) do
      delete article_comment_path(@article, comment),
          params: { article_id: @article.id, id: comment.id }, headers: @auth_headers
    end

    assert_redirected_to article_path(@article)
    assert_equal "Comment was successfully destroyed.", flash[:notice]
  end

  test "should not destroy comment if unauthorized" do
    comment = @article.comments.last
    assert_no_difference("Comment.count") do
      delete article_comment_path(@article, comment),
          params: { article_id: @article.id, id: comment.id }
    end

    assert_response :unauthorized
  end
end
