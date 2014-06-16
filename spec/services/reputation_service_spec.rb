require 'spec_helper'

describe ReputationService do
  describe '.process' do
    let(:receiver) { create :user }
    let(:message) { create :answer, author: receiver }
    let(:committer) { create :user }

    def process(action = :any)
      ReputationService.process action, message, committer
    end

    context 'when comitter is an author of message' do
      before { message.author = committer }

      it 'should not create reputation change' do
        expect { process }.to_not change(ReputationChange, :count)
      end
    end

    context 'action accept' do
      it 'should create 2 reputation changes' do
        expect { process :accept }.to change(ReputationChange, :count).by(2)
      end

      it 'should create 2 accept reputation changes' do
        process :accept
        expect(message.reputation_changes.accept.count).to eq(2)
      end

      it "should change receiver's reputation by 15" do
        expect { process :accept }.to change { receiver.reputation }.by(15)
      end

      it "should change committer's reputation by 2" do
        expect { process :accept }.to change { committer.reputation }.by(2)
      end
    end

    context 'action upvote' do
      it 'should create 1 reputation change' do
        expect { process :upvote }.to change(ReputationChange, :count).by(1)
      end

      it 'should create upvote reputation change' do
        process :upvote
        expect(message.reputation_changes.upvote.count).to eq(1)
      end

      context 'for answer' do
        it "should change receiver's reputation by 10" do
          expect { process :upvote }.to change { receiver.reputation }.by(10)
        end
      end

      context 'for question' do
        before { message.answer = false }

        it "should change receiver's reputation by 5" do
          expect { process :upvote }.to change { receiver.reputation }.by(5)
        end
      end
    end

    context 'action downvote' do
      it "should change receiver's reputation by -2" do
        expect { process :downvote }.to change { receiver.reputation }.by(-2)
      end

      context 'for answer' do
        it 'should create 2 reputation changes' do
          expect { process :downvote }.to change(ReputationChange, :count).by(2)
        end

        it 'should create 2 downvote reputation changes' do
          process :downvote
          expect(message.reputation_changes.downvote.count).to eq(2)
        end

        it "should change committer's reputation by -1" do
          expect { process :downvote }.to change { committer.reputation }.by(-1)
        end
      end

      context 'for question' do
        before { message.answer = false }

        it 'should create 1 reputation change' do
          expect { process :downvote }.to change(ReputationChange, :count).by(1)
        end

        it 'should create downvote reputation change' do
          process :downvote
          expect(message.reputation_changes.downvote.count).to eq(1)
        end
      end
    end
  end
end
