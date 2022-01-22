class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  broadcasts_to :article
end
