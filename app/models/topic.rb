class Topic < ActiveRecord::Base
  validates :title, presence: true
  validates :views, numericality: true

  has_one :question, -> { where(answer: false) }, class_name: 'Message'
  has_many :answers, -> { where(answer: true) }, class_name: 'Message'

  has_many :topic_tags
  has_many :tags, through: :topic_tags

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

  def process_tags(tags_string)
    return unless tags_string
    tags_string.split(',').each do |tag_name|
      tag = Tag.find_by_name(tag_name)
      tag = Tag.create(name: tag_name) unless tag
      self.tags << tag
    end
  end

  after_initialize :set_defaults

  private

  def set_defaults
    self.views ||= 0
  end
end
