require 'spec_helper'

describe TagsController, type: :controller do
  describe 'GET #index' do
    let(:tags) { create_list(:tag, 2) }
    before(:each) { get :index, format: :json }

    it 'populates an array of tags' do
      expect(assigns(:tags)).to match_array(tags)
    end
  end
end
