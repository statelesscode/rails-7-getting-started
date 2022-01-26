class RemoveBodyFromArticleAndComment < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :body, :text
    remove_column :comments, :body, :text
  end
end
