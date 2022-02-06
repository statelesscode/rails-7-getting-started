module RichTextBody
  extend ActiveSupport::Concern

  MIN_BODY_LENGTH = 10

  included do
    validates :body, presence: true
    validate :body_minimum_length
  end

  private
    def body_minimum_length
      if body.to_plain_text.length < MIN_BODY_LENGTH
        errors.add :body, :too_short, message: "is too short (minimum is #{MIN_BODY_LENGTH} characters)"
      end
    end
end
