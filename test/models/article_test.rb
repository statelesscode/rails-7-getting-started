require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  include VisibleTestHelpers

  def setup
    @article = articles(:nerd)
    @valid_title = "I have a valid title"
    @valid_body = "This body is long enough."
    @title_blank = "Title can't be blank"
    @body_blank = "Body can't be blank"
    @body_short = "Body is too short (minimum is 10 characters)"
    shared_status_setup
    @status_new = get_new_article
    @status_existing = @article
    @public_count = 1
    @klass_name = Article
  end

  test "has valid fixtures" do
    run_model_fixture_tests @klass_name
  end

  test "should be valid and creatable with correct attributes" do
    article = get_new_article
    assert article.valid?
    assert article.save
    article.reload
    assert_not_nil article.id
    assert_equal @valid_title, article.title
    assert_equal @valid_body, article.body
    assert_equal @valid_status, article.status
  end

  test "should be invalid if title is blank" do
    # new
    article = get_new_article
    article.title = nil
    assert_not article.valid?
    assert_includes article.errors.full_messages, @title_blank

    # existing with nil
    @article.title = nil
    assert_not @article.valid?
    assert_includes @article.errors.full_messages, @title_blank
  end

  test "should be invalid if body is blank" do
    # new
    article = get_new_article
    article.body = ""
    assert_not article.valid?
    assert_includes article.errors.full_messages, @body_blank

    # existing with empty string
    @article.body = ""
    assert_not @article.valid?
    assert_includes @article.errors.full_messages, @body_blank
  end

  test "should be invalid if body is too short" do
    too_short = "Fail"
    # new
    article = get_new_article
    article.body = too_short
    assert_not article.valid?
    assert_includes article.errors.full_messages, @body_short

    # existing
    @article.body = too_short
    assert_not @article.valid?
    assert_includes @article.errors.full_messages, @body_short
  end

  private
    def get_new_article
      Article.new(title: @valid_title, body: @valid_body, status: @valid_status)
    end
end
