require 'spec_helper'

RSpec.describe QuestionsMailer, type: :mailer do
  describe '#digest' do
    let(:topics) { create_list :topic, 2 }
    let(:date) { Time.now.midnight }
    let(:mail) { QuestionsMailer.digest(topics, date) }

    it 'sets subject' do
      expect(mail.subject).to eq "New questions digest for #{date}"
    end

    it 'renders question title' do
      expect(mail.body).to match(topics.last.title)
    end

    it 'renders question link' do
      url = "http://so-clone.herokuapp.com/questions/#{topics.last.id}"
      expect(mail.body).to match(url)
    end

    it 'mails to all users' do
      emails = topics.map { |t| t.author.email }
      emails << create(:user).email
      expect(mail.to.sort).to eq emails.sort
    end
  end
end
