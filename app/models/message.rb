class Message < ActiveRecord::Base
  belongs_to :topic

  validates :body, presence: true
end
