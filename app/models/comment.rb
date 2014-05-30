class Comment < ActiveRecord::Base
  belongs_to :author, class_name: 'User', inverse_of: :comments
  belongs_to :message, inverse_of: :comments, counter_cache: true
  validates :body, presence: true
end
