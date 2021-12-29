require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:nerd)
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
