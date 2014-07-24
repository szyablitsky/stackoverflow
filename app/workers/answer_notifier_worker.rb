class AnswerNotifierWorker
  include Sidekiq::Worker

  def perform(topic_id)
    topic = Topic.find(topic_id)
    AnswersMailer.notification(topic).deliver
  end
end
