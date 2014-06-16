class ReputationService
  def self.process(action, message, user)
    return if message.author == user
    self.send(action, message, user)
  end

  def self.accept(message, user)
    self.create_change 15, :accept, message, message.author, user
    self.create_change 2, :accept, message, user, user
  end

  def self.upvote(message, user)
    amount = message.answer ? 10 : 5
    self.create_change amount, :upvote, message, message.author, user
  end

  def self.downvote(message, user)
    self.create_change -2, :downvote, message, message.author, user
    self.create_change -1, :downvote, message, user, user if message.answer
  end

  def self.create_change(amount, type, message, receiver, committer)
    ReputationChange.create! do |change|
      change.amount = amount
      change.type = type
      change.message = message
      change.receiver = receiver
      change.committer = committer
    end
  end

  private_class_method :accept, :upvote, :downvote
end
