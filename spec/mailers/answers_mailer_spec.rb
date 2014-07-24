require "spec_helper"

RSpec.describe AnswersMailer, type: :mailer do
  describe '#notification' do
    let(:topic) { create :topic }
    let(:answer) { create :answer, topic: topic }
    let(:user) { create :user }
    let!(:subscription) { create :subscription, topic: topic, user: user }
    let(:mail) { AnswersMailer.notification(topic) }

    it 'sets subject' do
      expect(mail.subject).to eq "New answer for question"
    end

    it 'renders question title' do
      expect(mail.body).to match(topic.title)
    end

    it 'renders question link' do
      url = "http://so-clone.herokuapp.com/questions/#{topic.id}"
      expect(mail.body).to match(url)
    end

    it 'mails to all subscribed users' do
      emails = [ user.email, topic.question.author.email ] 
      expect(mail.to).to eq emails
    end
  end
end
