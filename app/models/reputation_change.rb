class ReputationChange < ActiveRecord::Base
  belongs_to :message
  belongs_to :receiver, class_name: 'User'
  belongs_to :committer, class_name: 'User'

  enum type: [:accept, :upvote, :downvote, :edit, :bounty]

  validates :amount, numericality: true

  def self.received_by(user)
    connection.select_all %Q(
      select t.id, t.title, c.amount, c.type, c.created_at,
             c.receiver_id, c.committer_id
      from reputation_changes c, messages m, topics t
      where t.id = m.topic_id
        and m.id = c.message_id
        and c.receiver_id = #{user.id}
      order by c.created_at desc
      limit 10)
  end
end
