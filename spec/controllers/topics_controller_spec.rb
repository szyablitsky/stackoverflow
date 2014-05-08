require 'spec_helper'

describe TopicsController do
  describe 'GET #index' do
    let(:topics) { create_list(:topic, 2) }
    before(:each) { get :index }

    it 'populates an array of topics' do
      expect(assigns(:topics)).to match_array(topics)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:topic) { create(:topic_with_answers) }
    before(:each) { get :show, id: topic }

    it 'populates a topic' do
      expect(assigns(:topic)).to eq topic
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    let(:form) { instance_double(QuestionForm) }

    before(:each) do
      allow(QuestionForm).to receive(:new) { form }
      login_user
      get :new
    end

    it 'creates a new Question form' do
      expect(assigns(:form)).to eq(form)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login_user }

    let(:topic_attributes) do
      a = attributes_for(:topic)
      a['question_attributes'] = attributes_for(:question)
      a
    end

    def create_topic
      post :create, question: topic_attributes
    end

    context 'with valid attributes' do
      it 'creates new topic' do
        expect { create_topic }.to change(Topic, :count).by(1)
      end

      it 'creates new question message' do
        expect { create_topic }.to change(Message, :count).by(1)
      end

      it 'redirects to show view' do
        create_topic
        expect(response).to redirect_to question_path(Topic.all.last)
      end
    end

    context 'with invalid attributes' do
      before do
        topic_attributes[:title] = nil
      end

      it 'does not create new topic' do
        expect { create_topic }.to_not change(Topic, :count)
      end

      it 'renders new view' do
        create_topic
        expect(response).to render_template :new
      end
    end
  end
end
