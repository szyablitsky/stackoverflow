class ReputationService
  def self.process(action, message, user)
    return if message.author == user
    service = self.new(message, user)
    service.process action
  end

  def initialize(message, user)
    @message, @user = message, user
  end

  def process(action)
    ActiveRecord::Base.transaction { self.send action }
  end

  private

  def accept
    create_change 15, :accept, @message.author
    create_change 2, :accept, @user
  end

  def upvote
    amount = @message.answer ? 10 : 5
    create_change amount, :upvote, @message.author
  end

  def downvote
    create_change -2, :downvote, @message.author
    create_change -1, :downvote, @user if @message.answer
  end

  def create_change(amount, type, receiver)
    ReputationChange.create! do |change|
      change.amount = amount
      change.type = type
      change.message = @message
      change.receiver = receiver
      change.committer = @user
    end
    receiver.reputation += amount
    receiver.save!
  end
end
