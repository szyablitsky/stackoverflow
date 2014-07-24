require 'spec_helper'

describe TopicsController, type: :controller do
  describe 'GET #index' do
    let(:topics) { create_list(:topic, 2) }
    before(:each) { get :index }

    it 'populates an array of topics' do
      expect(assigns(:topics)).to match_array(topics)
    end

    it 'decorates topics' do
      expect(assigns(:topics)).to be_decorated
    end
  end

  describe 'GET #show' do
    let(:topic) { create(:topic_with_answers, views: 10) }
    
    before { get :show, id: topic }

    it 'populates a topic' do
      expect(assigns(:topic)).to eq topic
    end

    it 'decorates a topic' do
      expect(assigns(:topic)).to be_decorated
    end

    it "populates an answer with new topic's message" do
      expect(assigns(:answer)).to eq assigns(:topic).answers.last
    end

    it 'increments views' do
      topic.reload
      expect(topic.views).to eq(11)
    end
  end

  describe 'GET #new' do
    before do
      login_user
      get :new
    end

    it 'creates a new topic' do
      expect(assigns(:topic)).to be_a_new(Topic)
    end

    it 'creates a new question' do
      expect(assigns(:topic).question).to be_a_new(Message)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:topic_attributes) do
      attributes_for(:topic)
        .merge(question_attributes: attributes_for(:question))
    end

    before { login user }

    def create_topic
      post :create, topic: topic_attributes
    end

    context 'with valid attributes' do
      it 'creates new topic' do
        expect { create_topic }.to change(Topic, :count).by(1)
      end

      it 'creates new question message linked to logged in user' do
        create_topic
        expect(assigns(:topic).question.author).to eq(user)
      end

      it 'creates subscription' do
        expect { create_topic }.to change(Subscription, :count).by(1)
      end

      it 'creates subscription for topic author' do
        create_topic
        expect(Subscription.last.user).to eq(user)
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
