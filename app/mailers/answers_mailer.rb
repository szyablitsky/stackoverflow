class AnswersMailer < ActionMailer::Base
  default from: 'info@so-clone.herokuapp.com',
          subject: 'New answer for question'

  def notification(topic)
    @topic = topic
    mail(to: User.subscribed_to(topic).pluck(:email))
  end
end
