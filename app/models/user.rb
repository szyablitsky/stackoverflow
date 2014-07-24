class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:github, :facebook]

  has_many :authorizations, dependent: :destroy
  has_many :messages, foreign_key: 'author_id', inverse_of: :author
  has_many :comments, foreign_key: 'author_id', inverse_of: :author
  has_many :received_reputation_changes, class_name: 'ReputationChange',
           foreign_key: 'receiver_id', inverse_of: :receiver
  has_many :committed_reputation_changes, class_name: 'ReputationChange',
           foreign_key: 'committer_id', inverse_of: :committer
  has_many :votes
  has_many :subscriptions

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :provider, :uid

  def self.subscribed_to(topic)
    joins(:subscriptions).where(subscriptions: { topic_id: topic })
  end

  def self.find_for_oauth(auth)
    auth_small = auth.slice(:provider, :uid)
    authorization = Authorization.where(auth_small).first
    return authorization.user if authorization

    user = User.where(email: auth.info[:email]).first
    if user
      user.authorizations.create! auth_small
    else
      user = User.new_for_oauth(auth)
    end
    user
  end

  def self.new_for_oauth(auth)
    User.new do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.name = auth.info.name
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      data = session['devise.omniauth_data'] &&
             session['devise.omniauth_data']['extra']['raw_info']
      if data
        user.name = data['name'] unless user.name?
        user.email = data['email'] unless user.email?
      end
    end
  end

  after_create :save_authorization, if: :provider

  private

  def save_authorization
    authorizations.create! provider: provider, uid: uid
  end
end
