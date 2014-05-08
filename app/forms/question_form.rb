class QuestionForm < Reform::Form
  property :title
  validates :title, presence: true

  property :question do
    property :body
    validates :body, presence: true
  end
end
