class Article < ApplicationRecord
  include Visible
  include RichTextBody

  has_many :comments, dependent: :destroy

  has_rich_text :body

  validates :title, presence: true

end
