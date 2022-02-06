require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:nerd)
    @spam_commenter = "Social Media Giant"
    @spam_body = "Visit the COVID-19 resource center so we can tell you what to think!"
  end

  test "destroying a comment" do
    visit construct_with_http_auth(edit_article_path(@article))
    visit article_url(@article)
    # add a spam comment
    fill_in "Commenter", with: @spam_commenter
    find("trix-editor").set(@spam_body)
    # accept default for status
    click_on "Create Comment"

    assert_text @spam_commenter
    assert_text @spam_body
    within("div#comment_#{@article.comments.last.id}") do
      page.accept_confirm do
        click_on "Destroy Comment"
      end
    end
    assert_text "Comment was successfully destroyed."
    assert_text @article.title
    assert_no_text @spam_commenter
    assert_no_text @spam_body
    assert_text "Comments"
    assert_text "Add a comment:"
  end

  test "destroying an article" do
    visit construct_with_http_auth(edit_article_path(@article))
    visit article_url(@article)
    page.accept_confirm do
      click_on "Destroy"
    end

    assert_text "Article was successfully destroyed."
    assert_text "Articles"
    assert_no_text @article.title
    assert_text articles(:why).title
    assert_text "New Article"
  end

  test "created comment broadcasts to article and adds to page" do
    visit article_url(@article)

    # validate that comment isn't in the DOM
    assert_no_text @spam_commenter
    assert_no_text @spam_body

    # create a comment outside of the page context
    @article.comments.create!(
      commenter: @spam_commenter,
      body: @spam_body,
      status: "public"
    )

    # validate that comment gets inserted into the DOM
    assert_text @spam_commenter
    assert_text @spam_body
  end

  test "destroyed comment broadcasts to article and removes from page" do
    visit article_url(@article)
    comment = @article.comments.create!(
      commenter: @spam_commenter,
      body: @spam_body,
      status: "public"
    )

    # validate that comment is in the DOM
    assert_text comment.commenter
    assert_text comment.body.to_plain_text

    # destroy the comment outside of the page context
    comment.destroy!

    # validate that comment is no longer in the DOM
    assert_no_text comment.commenter
    assert_no_text comment.body.to_plain_text
  end

  private
    def construct_with_http_auth(path)
      username = "stateless"
      password = "code"
      "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
    end
end
