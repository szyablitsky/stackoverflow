require 'spec_helper'

describe TopicDecorator do
  subject { create(:topic).decorate }

  describe '#votes_label' do
    it { expect(subject.votes_label).to eq 'votes' }
  end

  describe '#answers_class' do
    it { expect(subject.answers_class).to eq 'empty' }

    context 'with 1 answer' do
      before { subject.answers.create(attributes_for(:answer)) }
      it { expect(subject.answers_class).to be_nil }
    end
  end

  describe '#answers_label' do
    it { expect(subject.answers_label).to eq 'answers' }

    context 'with 1 answer' do
      before { subject.answers.create(attributes_for(:answer)) }
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
end
