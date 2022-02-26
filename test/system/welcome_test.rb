require "application_system_test_case"

class WelcomeTest < ApplicationSystemTestCase
  def setup
    @quotes = [
      "Mrs. Pecock was a man?! [slap]",
      "It's called a cruel irony, Kronk.",
      "Give him a sedagive!",
      "Ray, when someone asks if you're a god, you say YES!",
      "You like me because I'm a scoundrel. There aren't enough scoundrels in your life.",
      "Double the taxes! Triple the taxes! Squeeze every last drop out of those insolent, musical peasants."
    ]
    @intro = "Get started with Stimulus. Click Get next quote."
  end

  test "stimulus interaction works" do
    visit welcome_index_url

    reset_state_assertions

    click_on "Get next quote"
    n_left_assertions 5

    click_on "Get next quote"
    n_left_assertions 4

    click_on "Get next quote"
    n_left_assertions 3

    click_on "Reset"
    reset_state_assertions

    click_on "Get next quote"
    n_left_assertions 5

    click_on "Get next quote"
    n_left_assertions 4

    click_on "Get next quote"
    n_left_assertions 3

    click_on "Get next quote"
    n_left_assertions 2

    click_on "Get next quote"
    n_left_assertions 1

    click_on "Get next quote"
    n_left_assertions 0

    click_on "Reset"
    reset_state_assertions
  end

  private
    def reset_state_assertions
      assert_text "Stimulus Example"
      assert_text "Get started with Stimulus. Click Get next quote."
      assert_text "There are 6 quotes remaining."
      assert_button "Reset", disabled: true
      assert_button "Get next quote"
    end

    def n_left_assertions(number)
      index = 5 - number
      assert_text @quotes[index]
      base_text = "There are #{number} quotes remaining."
      case number
      when 0 then assert_text "#{base_text} Click reset to try again."
      when 1 then assert_text "There is 1 quote remaining"
      else assert_text base_text
      end
      assert_no_text "Get started with Stimulus. Click Get next quote."
      assert_button "Reset"
      assert_button "Get next quote", disabled: (number == 0)
    end
end
