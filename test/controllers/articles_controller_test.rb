require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @article = articles(:nerd)
    @title_blank = "Title can't be blank"
    @body_blank = "Body can't be blank"
    @body_short = "Body is too short (minimum is 10 characters)"
  end

  test "should get index" do
    get articles_url
    assert_response :success
    assert_select 'h1', 'Articles'
    assert_select 'li', Article.count
    assert_select 'a', 'New Article'
  end

  test "should get show" do
    get article_url(@article)
    assert_response :success
    assert_select 'h1', @article.title
    assert_select 'p', @article.body
  end

  test "should get new" do
    get new_article_url
    assert_response :success
    assert_select "h1", "New Article"
    assert_select "form"
    assert_select "form div", 3
  end

  test "should create article" do
    article_title = "Sleepy Time"
    article_body = "I'm asleep: #{'z' * 1000}"

    assert_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: article_title,
          body: article_body
        }
      }
    end

    article = Article.last
    assert_redirected_to article_path(article)
    assert_equal article_title, article.title
    assert_equal article_body, article.body
    assert_equal "Article was successfully created.", flash[:notice]
  end

  test "should display errors if validations fail" do
    assert_no_difference("Article.count") do
      post articles_url, params: {
        article: {
          title: "",
          body: ""
        }
      }
    end

    assert_select "h1", "New Article"
    assert_select "form"
    assert_select "div.error", 3
    assert_select "div.error", @title_blank
    assert_select "div.error", @body_blank
    assert_select "div.error", @body_short
  end
end
