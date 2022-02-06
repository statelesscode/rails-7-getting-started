class Comment < ApplicationRecord
  include Visible
  include RichTextBody

  belongs_to :article
  broadcasts_to :article

  has_rich_text :body

  validates :commenter, presence: true
end
