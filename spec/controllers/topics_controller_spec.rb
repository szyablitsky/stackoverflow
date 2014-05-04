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
    let(:topic) { create(:topic_with_messages) }
    before(:each) { get :show, id: topic }

    it 'populates a topic' do
      expect(assigns(:topic)).to eq topic
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end