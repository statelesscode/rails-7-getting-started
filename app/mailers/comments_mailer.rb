class CommentsMailer < ApplicationMailer
  default to: "mike@example.org"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comments_mailer.created.subject
  #
  def created(comment)
    @comment = comment

    mail subject: "Comment by #{@comment.commenter} has been created"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comments_mailer.destroyed.subject
  #
  def destroyed(commenter, body, status)
    @comment = Comment.new(
      commenter: commenter,
      body: body,
      status: status
    )

    mail subject: "Comment by #{commenter} has been destroyed"
  end
end
