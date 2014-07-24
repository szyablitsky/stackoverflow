ThinkingSphinx::Index.define :topic, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes tags.name, as: :tags
  indexes question.body, as: :body
  indexes question.comments.body, as: :comments
  indexes answers.body, as: :answers
  indexes answers.comments.body, as: :answers_comments

  # attributes
  has created_at, updated_at
end