class Topic < ActiveRecord::Base
  validates :title, presence: true
  validates :views, numericality: true

  has_one :question, -> { where(answer: false) }, class_name: 'Message'
  has_many :answers, -> { where(answer: true) }, class_name: 'Message'

  accepts_nested_attributes_for :question

  def increment_views
    self.views += 1
    self.save!
  end

  after_initialize :set_defaults
  
  private

  def set_defaults
    self.views ||= 0
  end    
end
