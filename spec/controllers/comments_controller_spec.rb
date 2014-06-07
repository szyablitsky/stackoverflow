require 'spec_helper'

describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:message) { create(:message) }
    let(:comment) { attributes_for(:comment) }
    let(:user) { create(:user, reputation: 50) }

    def create_comment
      post :create, message_id: message, comment: comment, format: :json
    end

    context 'for authenticated user' do
      before { login user }

      it 'creates comment linked to question' do
        expect { create_comment }.to change(message.comments, :count).by(1)
      end

      it 'creates comment linked to logged in user' do
        create_comment
        expect(assigns(:comment).author).to eq(user)
      end

      context 'with reputation less than 50' do
        before do
          user.reputation = 49
          user.save!
        end

        it 'does not create comment' do
          expect { create_comment }.to_not change(Comment, :count)
        end
      end
    end

    context 'for non authenticated user' do
      it 'should return unauthorized status' do
        create_comment
        expect(response.status).to eq 401
      end
    end
  end
end
