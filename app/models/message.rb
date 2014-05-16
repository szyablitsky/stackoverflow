class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :author, class_name: 'User', inverse_of: :messages

  validates :body, presence: true
end
