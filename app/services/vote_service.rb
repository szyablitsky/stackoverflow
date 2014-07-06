class VoteService
  def self.process(action, message, user)
    service = self.new(message, user)
    service.process(action)
    { score: message.score, type: message.decorate.type }
  end

  def initialize(message, user)
    @message, @user = message, user
  end

  def process(action)
    ActiveRecord::Base.transaction { self.send action }
  end

  private

  def voteup
    Vote.create! up: true, message: @message, user: @user
    @message.increment! :score
    ReputationService.process :upvote, @message, @user
  end

  def votedown
    Vote.create! up: false, message: @message, user: @user
    @message.decrement! :score
    ReputationService.process :downvote, @message, @user
  end
end
