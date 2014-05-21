require 'spec_helper'

describe UsersController do
  describe 'GET #show' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

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
end