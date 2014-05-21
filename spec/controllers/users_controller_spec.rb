require 'spec_helper'

describe UsersController do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'GET #show' do
    let(:topic1) do
      create :topic,
             question: create(:question, author: user1),
             answers: create_list(:answer, 2, author: user2)
    end

    let(:topic2) do
      create :topic,
             question: create(:question, author: user2),
             answers: create_list(:answer, 2, author: user1)
    end

    it "assigns only user's topics for user1" do
      get :show, id: user1

      expect(assigns(:questions)).to match_array [topic1]
      expect(assigns(:answers)).to match_array [topic2]
    end

    it "assigns only user's topics for user2" do
      get :show, id: user2

      expect(assigns(:questions)).to match_array [topic2]
      expect(assigns(:answers)).to match_array [topic1]
    end
  end

  describe 'PATCH #update' do
    def update(user)
      patch :update, id: user, user: { name: 'test' }
    end

    context 'when user signed in' do
      before { login user1 }

      context 'and updates his profile' do
        before { update user1 }
        it { expect(response).to redirect_to user_path(user1) }
        it 'profile updates' do
          user1.reload
          expect(user1.name).to eq 'test'
        end
      end

      context "and updates other user's profile" do
        before { update user2 }
        it { expect(response.status).to eq 403 }
      end
    end

    context 'when user not signed in' do
      before { update user1 }
      it { expect(response).to redirect_to new_user_session_path }
    end
  end
end