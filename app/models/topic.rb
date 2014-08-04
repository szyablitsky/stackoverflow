class Topic < ActiveRecord::Base
  validates :title, presence: true
  validates :views, numericality: true

  has_many :messages
  has_one :question, -> { where(answer: false) }, class_name: 'Message'
  has_many :answers, -> { where(answer: true).order(accepted: :desc, score: :desc, updated_at: :desc) },
           class_name: 'Message'

  has_many :topic_tags
  has_many :tags, through: :topic_tags

  has_many :subscriptions

  accepts_nested_attributes_for :question

  delegate :author, :author=, to: :question

  def self.for_home_page
    includes(:tags, question: :author).order(created_at: :desc).limit(20)
  end

  def self.with_questions_by(user)
    joins(:question).where(messages: { author_id: user })
      .order(updated_at: :desc).limit(10)
  end

  def self.with_answers_by(user)
    connection.select_all %Q(
      select t.id as topic_id, t.title, m.id as message_id
      from messages m, topics t
      where t.id = m.topic_id
        and m.answer = 't'
        and m.author_id = #{user.id}
      order by m.updated_at desc
      limit 10)
  end

  def self.daily_digest_for(range)
    order(:created_at).where(created_at: range)
  end

  def answers_count
    messages_count - 1
  end

  def has_answers?
    answers_count > 0
  end

  def has_accepted_answer?
    answers.select { |a| a.accepted }.size > 0
  end

  def answered_by?(user)
    if has_answers?
      answers.map { |answer| answer.author }.include? user
    else
      false
    end
  end

  def answer_id_by(user)
    answers.where(author: user).first.id
  end

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
