require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @article = articles(:nerd)
    @title_blank = "Title can't be blank"
    @body_blank = "Body can't be blank"
    @body_short = "Body is too short (minimum is 10 characters)"
    @article_title = "Sleepy Time"
    @valid_status = "public"
    @article_body = "I'm asleep: #{'z' * 1000}"
  end

  test "should get index" do
    get articles_url
    assert_response :success
    assert_select "h1", "Articles"
    assert_select "li", Article.count - 1
    assert_select "a", "New Article"
  end

  test "should get show" do
    get article_url(@article)
    assert_response :success
    assert_select "h1", @article.title
    assert_select "p", @article.body
    assert_select "a", "Edit"
    assert_select "a", "Destroy"
    assert_select "h2", "Comments"
    assert_select "p.commenter", @article.comments.count - 1
    assert_select "p.comment-body", @article.comments.count - 1
    assert_select "h2", "Add a comment:"
    assert_select "form"
    assert_select "form p", 3
  end

  test "should get new" do
    get new_article_url
    assert_response :success
    assert_select "h1", "New Article"
    assert_select "form"
    assert_select "form div", 3
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: @article_title,
          body: @article_body,
          status: @valid_status
        }
      }
    end

    saved_article_assertions(Article.last)
    assert_equal "Article was successfully created.", flash[:notice]
  end

  test "should display errors if create validations fail" do
    assert_no_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: "",
          body: ""
        }
      }
    end

    assert_select "h1", "New Article"
    form_error_assertions
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
    assert_select "h1", "Edit Article"
    assert_select "form"
    assert_select "form div", 3
  end

  test "should update article" do
    patch article_url(@article), params: {
      id: @article.id,
      article: {
        title: @article_title,
        body: @article_body
      }
    }

    @article.reload
    saved_article_assertions(@article)
    assert_equal "Article was successfully updated.", flash[:notice]
  end

  test "should display errors if update validations fail" do
    patch article_url(@article), params: {
      id: @article.id,
      article: {
        title: "",
        body: ""
      }
    }

    assert_select "h1", "Edit Article"
    form_error_assertions
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_path(Article.last), params: { id: Article.last.id }
    end

    assert_redirected_to articles_path
    assert_equal "Article was successfully destroyed.", flash[:notice]
  end

  private
    def saved_article_assertions(article)
      assert_redirected_to article_path(article)
      assert_equal @article_title, article.title
      assert_equal @article_body, article.body
    end

    def form_error_assertions
      assert_select "form"
      assert_select "div.error", 3
      assert_select "div.error", @title_blank
      assert_select "div.error", @body_blank
      assert_select "div.error", @body_short
    end
end
