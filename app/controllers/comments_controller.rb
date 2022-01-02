class CommentsController < ApplicationController
  http_basic_authenticate_with name: "stateless", password: "code", only: :destroy

  before_action :set_article

  def create
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article), notice: "Comment was successfully created."
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article), status: :see_other, notice: "Comment was successfully destroyed."
  end

  private
    def set_article
      @article = Article.find(params[:article_id])
    end

    def comment_params
      params.require(:comment).permit(:commenter, :body, :status)
    end
end
