require 'spec_helper'

describe VoteService do
  describe '.process' do
    let (:user) { create :user }

    shared_examples_for 'vote' do
      def process
        VoteService.process action, message, user
      end

      it 'creates new vote' do
        params = { up: up, message: message, user: user }
        expect(Vote).to receive(:create!).with(params)
        process
      end

      it "modifies message's score" do
        expect { process }.to change { message.score }.by(score)
      end

      it 'calls reputation service' do
        expect(ReputationService).to receive(:process)
          .with(direction, message, user)
        process
      end

      it 'returns score hash' do
        expect(process).to eq({ score: score, type: resource_type })
      end
    end

    context 'upvote' do
      let(:action) { :voteup }
      let(:direction) { :upvote }
      let(:up) { true }
      let(:score) { 1 }

      context 'question' do
        let(:message) { create :question }
        let(:resource_type) { 'question' }

        it_behaves_like 'vote'
      end

      context 'answer' do
        let(:message) { create :answer }
        let(:resource_type) { 'answer' }

        it_behaves_like 'vote'
      end
    end

    context 'downvote' do
      let(:action) { :votedown }
      let(:direction) { :downvote }
      let(:up) { false }
      let(:score) { -1 }

      context 'question' do
        let(:message) { create :question }
        let(:resource_type) { 'question' }

        it_behaves_like 'vote'
      end

      context 'answer' do
        let(:message) { create :answer }
        let(:resource_type) { 'answer' }

        it_behaves_like 'vote'
      end
    end
  end
end
