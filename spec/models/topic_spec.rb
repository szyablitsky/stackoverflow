require 'spec_helper'

describe Topic, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_numericality_of :views }
  it { is_expected.to have_many(:topic_tags) }
  it { is_expected.to have_many(:tags).through(:topic_tags) }
  it { is_expected.to have_many(:messages) }
  it { is_expected.to have_many(:subscriptions) }

  it do
    is_expected.to have_one(:question)
      .class_name('Message').conditions(answer: false)
  end

  it { is_expected.to accept_nested_attributes_for :question }

  it do
    is_expected.to have_many(:answers)
      .class_name('Message').conditions(answer: true)
  end

  it { is_expected.to delegate(:author).to(:question) }
  it { is_expected.to delegate(:author=).to(:question) }
  
  describe '#increment_views' do
    let!(:topic) { create(:topic) }

    it 'increments views value by 1' do
      expect { topic.increment_views }.to change { topic.views }.by(1)
    end
  end

  describe '#with_questions_by' do
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:topic1) { create :topic, question: create(:question, author: user1) }
    let(:topic2) { create :topic, question: create(:question, author: user2) }

    it "returns only user's topics" do
      expect(Topic.with_questions_by user1).to match_array [topic1]
    end
  end

  describe '#with_answers_by' do
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:answer1) { create :answer, author: user1 }
    let(:answer2) { create :answer, author: user2 }
    let(:answer3) { create :answer, author: user1 }
    let(:answer4) { create :answer, author: user2 }

    let(:topic1) do
      create :topic,
             question: create(:question, author: user1),
             answers: [answer1, answer2]
    end

    let(:topic2) do
      create :topic,
             question: create(:question, author: user2),
             answers: [answer3, answer4]
    end

    it "returns only user's answers" do
      answer_info1 = {
        'topic_id'   => topic1.id.to_s,
        'title'      => topic1.title,
        'message_id' => answer1.id.to_s
      }
      answer_info2 = {
        'topic_id'   => topic2.id.to_s,
        'title'      => topic2.title,
        'message_id' => answer3.id.to_s
      }

      expect(Topic.with_answers_by user1).to match_array [answer_info1, answer_info2]
    end
  end

  def prepare_topic_with_answer(user = nil)
    subject.title = 'title'
    subject.save!
    subject.create_question attributes_for(:question)

    add_answer user

    subject.reload
  end

  def add_answer(user)
    attributes = attributes_for(:answer)
    attributes.merge!(author: user) if user
    subject.answers.create attributes
  end    

  describe '#has_answers?' do
    context 'when answers exist' do
      before { prepare_topic_with_answer }
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
      before { prepare_topic_with_answer(user) }
      it { expect(subject.answered_by? user).to eq true }
    end

    context 'when answer by other user exist' do
      before { prepare_topic_with_answer(other_user) }
      it { expect(subject.answered_by? user).to eq false }
    end

    context 'when no answers exist' do
      it { expect(subject.answered_by? user).to eq false }
    end
  end

  describe '#answer_id_by' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      prepare_topic_with_answer(other_user)
      @answer = add_answer(user)
    end

    it { expect(subject.answer_id_by user).to eq @answer.id }
  end

  describe '#initalize' do
    it 'should set default value for views' do
      expect(subject.views).to eq 0
    end
  end
end
