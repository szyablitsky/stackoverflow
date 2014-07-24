class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    guest_abilities
    user_abilities if user
  end

  private

  def guest_abilities
    can :read, :all
    can :home, Topic
  end

  def user_abilities
    can :create, [Topic, Message]
    can :create, Comment if @user.reputation >= Privilege.create_comment

    can :update, [Topic, Message], author: @user
    can :update, User, id: @user.id

    can :accept, Message, answer: true,
        topic: { author: @user, has_accepted_answer?: false }

    can :subscribe, Topic do |topic|
      topic.subscriptions.where(user: @user).size == 0
    end
    can :unsubscribe, Topic do |topic|
      topic.subscriptions.where(user: @user).size > 0
    end

    vote :voteup
    vote :votedown
  end

  def vote(vote_type)
    if @user.reputation >= Privilege.send(vote_type)
      can(vote_type, Message) do |message|
        message.author != @user && message.not_voted_by?(@user)
      end
    end
  end
end
