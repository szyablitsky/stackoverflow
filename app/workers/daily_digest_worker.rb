class DailyDigestWorker
  include Sidekiq::Worker

  # travis-ci incompatibility
  # include Sidetiq::Schedulable
  # recurrence { daily }

  def perform
    today = Time.now.midnight
    yesterday = today - 1.day
    range = yesterday..today
    topics = Topic.daily_digest_for(range)
    QuestionsMailer.digest(topics, yesterday).deliver
  end
end
