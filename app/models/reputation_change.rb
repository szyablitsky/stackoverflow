class ReputationChange < ActiveRecord::Base
  belongs_to :message
  belongs_to :receiver, class_name: 'User'
  belongs_to :committer, class_name: 'User'

  enum type: [:accept, :upvote, :downvote, :edit, :bounty]

  validates :amount, numericality: true

  after_create :update_receiver_reputation

  def update_receiver_reputation
    receiver.reputation += amount
    receiver.save!
  end
end
