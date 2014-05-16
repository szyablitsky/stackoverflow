class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :messages, inverse_of: :author

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
