class Topic < ActiveRecord::Base
  validates :title, presence: true
  has_one :question, -> { where(answer: false) }, class_name: 'Message'
  has_many :answers, -> { where(answer: true) }, class_name: 'Message'
end
