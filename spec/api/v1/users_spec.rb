require 'spec_helper'

RSpec.describe 'Users API' do
  describe 'resource owner profile' do
    context 'when unauthorized' do
      it 'returns 401 status if no access token provided' do
        get '/api/v1/users/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if invalid access token provided' do
        get '/api/v1/users/me', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:token) { create :access_token, resource_owner_id: user.id }

      before do
        get '/api/v1/users/me', format: :json, access_token: token.token
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      %w(id name email reputation created_at updated_at).each do |attribute|
        it "returns user's #{attribute}" do
          json_val = user.send(attribute.to_sym).to_json
          expect(response.body).to be_json_eql(json_val).at_path("user/#{attribute}")
        end
      end

      %w(password encrypted_password).each do |attribute|
        it "does not contain #{attribute}" do
          expect(response.body).to_not have_json_path("user/#{attribute}")
        end
      end
    end
  end

  describe 'user profiles' do
    context 'when unauthorized' do
      it 'returns 401 status if no access token provided' do
        get '/api/v1/users', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if invalid access token provided' do
        get '/api/v1/users', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:user1) { create :user }
      let(:user2) { create :user }
      let!(:users) { [user2, user1] }
      let(:token) { create :access_token, resource_owner_id: user1.id }

      before do
        get '/api/v1/users', format: :json, access_token: token.token
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns an array of 2 objects' do
        expect(response.body).to have_json_size(2).at_path('users')
      end

      %w(id name email reputation created_at updated_at).each do |attribute|
        it "returns #{attribute} for each user" do
          users.each_with_index do |user, i|
            json_val = user.send(attribute.to_sym).to_json
            expect(response.body).to be_json_eql(json_val).at_path("users/#{i}/#{attribute}")
          end
        end
      end

      %w(password encrypted_password).each do |attribute|
        (0..1).each do |i|
          it "does not contain #{attribute} at index #{i}" do
            expect(response.body).to_not have_json_path("users/#{i}/#{attribute}")
          end
        end
      end
    end
  end
end
