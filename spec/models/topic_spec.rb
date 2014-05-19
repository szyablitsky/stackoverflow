require 'spec_helper'

describe Topic do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to validate_numericality_of :views }

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

  describe '#initalize' do
    it 'should set default value for views' do
      expect(subject.views).to eq 0
    end
  end
end
