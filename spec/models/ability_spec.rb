require 'spec_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject { Ability.new(user) }

  context 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, :all }
    it { is_expected.not_to be_able_to :create, :all }
    it { is_expected.not_to be_able_to :update, :all }
    it { is_expected.not_to be_able_to :destroy, :all }
  end

  context 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:topic) { create :topic }
    let(:answer) { create :answer, topic: topic }

    it { is_expected.to be_able_to :create, Topic }
    it { is_expected.to be_able_to :create, Message }

    context 'trying to create comment' do
      context 'and having default reputation' do
        it { is_expected.not_to be_able_to :create, Comment }
      end

      context 'and having enough reputation' do
        before { user.update_attribute :reputation, 50 }
        it { is_expected.to be_able_to :create, Comment }
      end
    end

    context 'and his question' do
      before { topic.update_attribute :author, user }
      it { is_expected.to be_able_to :update, topic }
      it { is_expected.to be_able_to :accept, answer }
      it { is_expected.not_to be_able_to :accept, topic.question }

      context 'that already accepted' do
        before { create :answer, topic: topic, accepted: true }
        it { is_expected.not_to be_able_to :accept, answer }
      end
    end

    context "and other user's question" do
      before { topic.update_attribute :author, other_user }
      it { is_expected.not_to be_able_to :update, topic }
      it { is_expected.not_to be_able_to :accept, answer }
    end

    context 'and his answer' do
      before { answer.update_attribute :author, user }
      it { is_expected.to be_able_to :update, answer }
    end

    context "and other user's answer" do
      before { answer.update_attribute :author, other_user }
      it { is_expected.not_to be_able_to :update, answer }
    end

    context 'trying to subscribe' do
      context 'and already subscribed' do
        before { create :subscription, topic: topic, user: user }
        it { is_expected.not_to be_able_to :subscribe, topic }
        it { is_expected.to be_able_to :unsubscribe, topic }
      end

      context 'and not subscribed' do
        it { is_expected.to be_able_to :subscribe, topic }
        it { is_expected.not_to be_able_to :unsubscribe, topic }
      end
    end
  end
end
