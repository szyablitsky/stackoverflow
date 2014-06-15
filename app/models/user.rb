class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :authorizations, dependent: :destroy
  has_many :messages, foreign_key: 'author_id', inverse_of: :author
  has_many :comments, foreign_key: 'author_id', inverse_of: :author

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :provider, :uid

  def self.find_for_oauth(auth)
    auth_small = auth.slice(:provider, :uid)
    authorization = Authorization.where(auth_small).first
    return authorization.user if authorization

    user = User.where(email: auth.info[:email]).first
    if user
      user.authorizations.create! auth_small
    else
      user = User.new do |user|
               user.provider = auth.provider
               user.uid = auth.uid
               user.name = auth.info.name
               user.email = auth.info.email
               user.password = Devise.friendly_token[0,20]
             end 
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] &&
                session["devise.facebook_data"]["extra"]["raw_info"]
        user.name = data["name"] if user.name.blank?
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  after_create :save_authorization, if: :provider

  private

  def save_authorization
    authorizations.create! provider: provider, uid: uid
  end
end
