class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    today = Time.now.midnight
    yesterday = today - 1.day
    range = yesterday..today
    topics = Topic.order(:created_at).where(created_at: range)
    QuestionsMailer.digest(topics, yesterday).deliver
  end
end
