require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  include VisibleTestHelpers
  include RichTextBodyTestHelpers

  def setup
    @article = articles(:nerd)
    @valid_title = "I have a valid title"
    @valid_body = "This body is long enough."
    @title_blank = "Title can't be blank"
    shared_status_setup
    shared_body_setup
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
    assert_equal @valid_body, article.body.to_plain_text
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

  private
    def get_new_article
      Article.new(title: @valid_title, body: @valid_body, status: @valid_status)
    end
end
