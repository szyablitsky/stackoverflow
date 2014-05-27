require 'spec_helper'

describe Topic do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_numericality_of :views }
  it { expect(subject).to accept_nested_attributes_for :question }

  it do
    expect(subject).to have_one(:question)
      .class_name('Message').conditions(answer: false)
  end

  it do
    expect(subject).to have_many(:answers)
      .class_name('Message').conditions(answer: true)
  end

  describe '#increment_views' do
    let!(:topic) { create(:topic) }

    it 'increments views value by 1' do
      expect { topic.increment_views }.to change { topic.views }.by(1)
    end
  end

  describe '#has_answers?' do
    context 'when answers exist' do
      before do
        subject.title = 'title'
        subject.save!
        subject.answers.create(body: 'body')
      end

      it { expect(subject.has_answers?).to eq true }
    end

    context 'when no answers exist' do
      it { expect(subject.has_answers?).to eq false }
    end
  end

  describe '#answered_by?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when answer by user exist' do
      before do
        subject.title = 'title'
        subject.save!
        subject.answers.create(body: 'body', author: user)
      end

      it { expect(subject.answered_by? user).to eq true }
    end

    context 'when answer by other user exist' do
      before do
        subject.title = 'title'
        subject.save!
        subject.answers.create(body: 'body', author: other_user)
      end

      it { expect(subject.answered_by? user).to eq false }
    end

    context 'when no answers exist' do
      it { expect(subject.answered_by? user).to eq false }
    end
  end

  describe '#initalize' do
    it 'should set default value for views' do
      expect(subject.views).to eq 0
    end
  end
end
