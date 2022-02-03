require "test_helper"

class CommentsMailerTest < ActionMailer::TestCase

  def setup
    @comment = comments(:nerd_gm)
    @subject_base = "Comment by Nerdy Game Master"
    @visible_section = "The following public comment has been"
  end

  test "created" do
    mail = CommentsMailer.created(@comment)
    assert_equal "#{@subject_base} has been created", mail.subject
    assert_equal ["mike@example.org"], mail.to
    assert_equal ["statelesscode@example.com"], mail.from
    assert_match "#{@visible_section} created:", mail.body.encoded
    assert_match @comment.body.to_plain_text, mail.body.encoded
  end

  test "destroyed" do
    body = "This is a comment"
    mail = CommentsMailer.destroyed(@comment.commenter, body, @comment.status)
    assert_equal "#{@subject_base} has been destroyed", mail.subject
    assert_equal ["mike@example.org"], mail.to
    assert_equal ["statelesscode@example.com"], mail.from
    assert_match "#{@visible_section} destroyed:", mail.body.encoded
    assert_match body, mail.body.encoded
  end

end
