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

  def self.with_questions_by(user)
    joins(:question).where messages: { author_id: user }
  end

  def self.with_answers_by(user)
    joins(:answers).where(messages: { author_id: user }).distinct
  end

  def has_answers?
    answers.count > 0
  end

  def answered_by?(user)
    if has_answers?
      answers.map { |answer| answer.author }.include? user
    else
      false
    end
  end

  after_initialize :set_defaults

  private

  def set_defaults
    self.views ||= 0
  end
end
