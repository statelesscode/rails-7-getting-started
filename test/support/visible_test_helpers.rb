module VisibleTestHelpers
  extend ActiveSupport::Concern

  def shared_status_setup
    @bad_status = "Censored"
    @valid_status = "public"
    @status_inclusion = "Status is not included in the list"
  end

  included do
    test "should be invalid with bad status" do
      # new
      @status_new.status = @bad_status
      assert_not @status_new.valid?
      assert_includes @status_new.errors.full_messages, @status_inclusion
      # existing
      @status_existing.status = @bad_status
      assert_not @status_existing.valid?
      assert_includes @status_existing.errors.full_messages, @status_inclusion
    end

    test "archived should be true if archived" do
      @status_existing.status = "archived"
      assert @status_existing.archived?
    end

    test "archived should be false if not archived" do
      assert_not @status_existing.archived?
      @article.status = "private"
      assert_not @status_existing.archived?
    end

    test "public count matches number of public records" do
      assert_equal @public_count, @klass_name.public_count
    end
  end
end
