class Message < ActiveRecord::Base
  belongs_to :topic, counter_cache: true
  belongs_to :author, class_name: 'User', inverse_of: :messages
  has_many :comments, inverse_of: :message
  has_many :attachments, inverse_of: :message
  has_many :reputation_changes
  has_many :votes

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  validates :body, presence: true
  validates :score, numericality: true

  def has_attachments?
    attachments_count > 0
  end

  def has_comments?
    comments_count > 0
  end

  def not_voted_by?(user)
    votes.where(user: user).count == 0
  end
end
