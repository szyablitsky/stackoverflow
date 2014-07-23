class QuestionsMailer < ActionMailer::Base
  default to: Proc.new { User.pluck(:email) },
          from: 'info@so-clone.herokuapp.com'

  def digest(topics, date)
    @topics = topics
    mail(subject: "New questions digest for #{date}")
  end
end
