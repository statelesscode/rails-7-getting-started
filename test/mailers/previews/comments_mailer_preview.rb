# Preview all emails at http://localhost:3000/rails/mailers/comments_mailer
class CommentsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/comments_mailer/created
  def created
    CommentsMailer.created(Comment.last)
  end

  # Preview this email at http://localhost:3000/rails/mailers/comments_mailer/destroyed
  def destroyed
    comment = Comment.last
    CommentsMailer.destroyed(comment.commenter, comment.body, comment.status)
  end

end
