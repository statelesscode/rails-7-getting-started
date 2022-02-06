module RichTextBodyTestHelpers
  extend ActiveSupport::Concern

  def shared_body_setup
    @body_blank = "Body can't be blank"
    @body_short = "Body is too short (minimum is 10 characters)"
  end

  included do
    test "should be invalid if body is blank" do
      # new
      @status_new.body = ""
      assert_not @status_new.valid?
      assert_includes @status_new.errors.full_messages, @body_blank

      # existing with empty string
      @status_existing.body = ""
      assert_not @status_existing.valid?
      assert_includes @status_existing.errors.full_messages, @body_blank
    end

    test "should be invalid if body is too short" do
      too_short = "Fail"
      # new
      @status_new.body = too_short
      assert_not @status_new.valid?
      assert_includes @status_new.errors.full_messages, @body_short

      # existing
      @status_existing.body = too_short
      assert_not @status_existing.valid?
      assert_includes @status_existing.errors.full_messages, @body_short
    end
  end
end
