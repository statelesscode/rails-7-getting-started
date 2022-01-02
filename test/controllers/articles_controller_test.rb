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
    @auth_headers = generate_auth_headers
  end

  test "should get index" do
    get articles_url
    assert_response :success
    assert_select "h1", "Articles"
    assert_select "li", Article.count - 1
    assert_select "a", "New Article"
    assert_select "p.public-count", "Our blog has 1 article and counting!"
  end

  test "should get show" do
    get article_url(@article), headers: @auth_headers
    assert_response :success
    assert_select "h1", @article.title
    assert_select "p", @article.body
    assert_select "a", "Edit"
    assert_select "a", "Destroy"
    assert_select "h2", "Comments"
    assert_select "p.commenter", @article.comments.count - 1
    assert_select "p.comment-body", @article.comments.count - 1
    assert_select "p.destroy-comment", @article.comments.count - 1
    assert_select "h2", "Add a comment:"
    assert_select "form"
    assert_select "form p", 4
    status_option_assertions
  end

  test "should not get show if unauthorized" do
    get article_url(@article)
    assert_response :unauthorized
  end

  test "should get new" do
    get new_article_url, headers: @auth_headers
    assert_response :success
    assert_select "h1", "New Article"
    article_form_assertions
  end

  test "should not get new if unauthorized" do
    get new_article_url
    assert_response :unauthorized
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: @article_title,
          body: @article_body,
          status: @valid_status
        }
      }, headers: @auth_headers
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
      }, headers: @auth_headers
    end

    assert_select "h1", "New Article"
    form_error_assertions
  end


  test "should not post create if unauthorized" do
    assert_no_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: @article_title,
          body: @article_body,
          status: @valid_status
        }
      }
    end
    assert_response :unauthorized
  end

  test "should get edit" do
    get edit_article_url(@article), headers: @auth_headers
    assert_response :success
    assert_select "h1", "Edit Article"
    article_form_assertions
  end

  test "should not get edit if unauthorized" do
    get edit_article_url(@article)
    assert_response :unauthorized
  end

  test "should update article" do
    patch article_url(@article), params: {
      id: @article.id,
      article: {
        title: @article_title,
        body: @article_body
      }
    }, headers: @auth_headers

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
    }, headers: @auth_headers

    assert_select "h1", "Edit Article"
    form_error_assertions
  end

  test "should not update article if unauthorized" do
    patch article_url(@article), params: {
      id: @article.id,
      article: {
        title: @article_title,
        body: @article_body
      }
    }

    assert_response :unauthorized
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_path(Article.last), params: { id: Article.last.id }, headers: @auth_headers
    end

    assert_redirected_to articles_path
    assert_equal "Article was successfully destroyed.", flash[:notice]
  end

  test "should not destroy article if unauthorized" do
    assert_no_difference("Article.count") do
      delete article_path(Article.last), params: { id: Article.last.id }
    end

    assert_response :unauthorized
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

    def article_form_assertions
      assert_select "form"
      assert_select "form div", 4
      status_option_assertions
    end

    def status_option_assertions
      assert_select "select option", 3
      assert_select "option", "public"
      assert_select "option", "private"
      assert_select "option", "archived"
    end
end
