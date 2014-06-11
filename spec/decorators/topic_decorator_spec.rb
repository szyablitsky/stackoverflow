require 'spec_helper'

describe TopicDecorator do
  subject { create(:topic).decorate }

  describe '#votes_label' do
    it { expect(subject.votes_label).to eq 'votes' }
  end

  def create_answer
    subject.answers.create attributes_for(:answer)
    subject.reload
  end

  describe '#answers_class' do
    it { expect(subject.answers_class).to eq 'empty' }

    context 'with 1 answer' do
      before { create_answer }
      it { expect(subject.answers_class).to be_nil }
    end
  end

  describe '#answers_label' do
    it { expect(subject.answers_label).to eq 'answers' }

    context 'with 1 answer' do
      before { create_answer }
      it { expect(subject.answers_label).to eq 'answer' }
    end
  end

  describe '#views_label' do
    it { expect(subject.views_label).to eq 'views' }

    context 'with 1 view' do
      before { subject.views = 1 }
      it { expect(subject.views_label).to eq 'view' }
    end
  end

  describe '#message_id_by' do
    let(:user) { create(:user) }
    let!(:answer) { subject.answers.create(body: 'body', author: user) }

    it { expect(subject.message_id_by user).to eq "#message-#{answer.id}" }
  end
end
