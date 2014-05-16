require 'spec_helper'

describe MessagesController do
  describe 'POST #create' do
    let!(:topic) { create(:topic_with_question) }
    let(:answer) { attributes_for(:answer) }
    let(:user) { create(:user) }

    before { login user }

    def create_answer
      post :create, question_id: topic, message: answer, format: :js
    end

    it 'renders create template' do
      create_answer
      expect(response).to render_template :create
    end

    it 'creates answer linked to topic' do
      expect { create_answer }.to change(topic.answers, :count).by(1)
    end

    it 'creates answer linked to logged in user' do
      create_answer
      expect(assigns(:answer).author).to eq(user)
    end
  end
end
