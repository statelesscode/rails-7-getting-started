require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:nerd)
  end

  test "destroying a comment" do
    spam_commenter = "Social Media Giant"
    spam_body = "Visit the COVID-19 resource center so we can tell you what to think!"
    visit article_url(@article)

    # add a spam comment
    fill_in "Commenter", with: spam_commenter
    fill_in "Body", with: spam_body
    # accept default for status
    click_on "Create Comment"

    assert_text spam_commenter
    assert_text spam_body

    within("div#comment_#{@article.comments.last.id}") do
      page.accept_confirm do
        click_on "Destroy Comment"
      end
    end

    assert_text "Comment was successfully destroyed."
    assert_text @article.title
    assert_no_text spam_commenter
    assert_no_text spam_body
    assert_text "Comments"
    assert_text "Add a comment:"
  end

  test "destroying an article" do
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
end
