require 'spec_helper'

describe MessagesController do
  describe 'POST #create' do
    let!(:topic) { create(:topic_with_question) }
    let(:answer) { attributes_for(:answer) }
    let(:user) { create(:user) }

    before { sign_in user }

    def create_answer
      post :create, question_id: topic, message: answer, format: :js
    end

    it 'renders create template' do
      create_answer
      expect(response).to render_template :create
    end

    it 'with valid data creates answer' do
      expect { create_answer }.to change(topic.answers, :count).by(1)
    end

    it 'with empty body does not create answer' do
      answer['body'] = nil
      expect { create_answer }.to_not change(Message, :count)
    end
  end
end
