require 'spec_helper'

RSpec.describe AnswerNotifierWorker do
  let(:topic) { create :topic }
  let(:answer) { create :answer, topic: topic }

  describe '#perform' do
    it 'sends email' do
      expect { subject.perform(topic.id) }
        .to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'sends notification' do
      subject.perform(topic.id)
      expect(ActionMailer::Base.deliveries.last.subject)
        .to match('New answer for question')
    end

    it 'sends notification for answered question' do
      subject.perform(topic.id)
      expect(ActionMailer::Base.deliveries.last.body).to match(topic.title)
    end
  end
end
