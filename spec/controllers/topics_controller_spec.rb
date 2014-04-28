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
end