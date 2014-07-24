require 'spec_helper'

describe MessagesController, type: :controller do
  describe 'POST #create' do
    let!(:topic) { create(:topic) }
    let(:answer) { attributes_for(:answer) }
    let(:user) { create(:user) }

    def create_answer
      post :create, question_id: topic, message: answer, format: :js
    end

    context 'for authenticated user' do
      before { login user }

      it 'creates answer linked to topic' do
        expect { create_answer }.to change(topic.answers, :count).by(1)
      end

      it 'creates answer linked to logged in user' do
        create_answer
        expect(topic.answers.first.author).to eq(user)
      end

      it 'performs notification delivery' do
        expect(AnswerNotifierWorker).to receive(:perform_async).with(topic.id)
        create_answer
      end

      context 'when already answered by this user' do
        before { topic.answers.create(body: 'body', author: user) }

        it 'assigns aswered to true' do
          create_answer
          expect(assigns(:answered)).to eq true
        end
      end
    end

    context 'for non authenticated user' do
      it 'should return unauthorized status' do
        create_answer
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #accept' do
    let(:topic) { create(:topic) }
    let(:user) { create(:user) }
    let(:answer) { create(:answer, topic: topic) }

    def accept_answer
      post :accept, controller: :messages, question_id: topic, id: answer , format: :js
    end

    context 'for authenticated user' do
      before do
        topic.question.author = user
        topic.save!
      end

      context 'when accepting answer for his own question' do
        before { login user }

        it 'changes accepted attribute to true' do
          accept_answer
          answer.reload
          expect(answer.accepted).to eq true
        end

        it 'processes reputation change' do
          expect(ReputationService).to receive(:process)
            .with(:accept, answer, user)
          accept_answer
        end

        context 'and topic already have accepted answer' do
          before { create(:answer, topic: topic, accepted: true) }

          it 'responds with method forbidden status' do
            accept_answer
            expect(response.status).to eq 403
          end
        end
      end

      context "when accepting answer for other user's question" do
        let(:other_user) { create(:user) }
        before { login other_user }

        it 'responds with forbidden status' do
          accept_answer
          expect(response.status).to eq 403
        end
      end
    end

    context 'for non authenticated user' do
      it 'responds with unauthorized status' do
        accept_answer
        expect(response.status).to eq 401
      end
    end
  end

  shared_examples_for 'vote' do
    let(:topic) { create :topic }
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:answer) { create(:answer, topic: topic, author: other_user) }

    def vote_answer
      post action, controller: :messages, question_id: topic,
           id: answer, format: :json
    end

    context 'for authenticated user' do
      before { login user }

      context 'with ehough reputation' do
        before { user.update_attribute :reputation, reputation }

        it 'processes vote' do
          expect(VoteService).to receive(:process)
            .with(action, answer, user)
          vote_answer
        end

        context 'and user already voted' do
          before { create(:vote, message: answer, user: user) }

          it 'responds with method forbidden status' do
            vote_answer
            expect(response.status).to eq 403
          end
        end

        context 'and his own answer' do
          before { answer.update_attribute :author, user }

          it 'responds with method forbidden status' do
            vote_answer
            expect(response.status).to eq 403
          end
        end
      end

      context 'with low reputation' do
        it 'responds with forbidden status' do
          vote_answer
          expect(response.status).to eq 403
        end
      end
    end

    context 'for non authenticated user' do
      it 'responds with unauthorized status' do
        vote_answer
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #voteup' do
    let(:action) { :voteup }
    let(:reputation) { Privilege.voteup }
    let(:score) { 1 }

    it_behaves_like 'vote'
  end

  describe 'POST #votedown' do
    let(:action) { :votedown }
    let(:reputation) { Privilege.votedown }
    let(:score) { -1 }

    it_behaves_like 'vote'
  end
end
