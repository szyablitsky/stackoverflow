require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to have_many :authorizations }
  it { is_expected.to have_many(:messages).with_foreign_key('author_id') }
  it { is_expected.to have_many(:comments).with_foreign_key('author_id') }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  describe '.find_for_facebook_oauth' do
    let(:attributes) { attributes_for :authorization }
    let(:auth) { OmniAuth::AuthHash.new(attributes) }

    def call; User.find_for_oauth(auth); end
    def authorization; call.authorizations.first; end

    context 'registered user' do
      let!(:user) { create :user }

      context 'already signed in with facebook' do
        before { user.authorizations.create(attributes) }

        it { expect(call).to eq user }
      end

      context 'first time signs in with facebook' do
        before { auth.merge! info: { email: user.email } }

        it { expect { call }.to change(user.authorizations, :count).by(1) }
        it { expect(authorization.provider).to eq auth.provider }
        it { expect(authorization.uid).to eq auth.uid }
      end
    end

    context 'unregistered user' do
      before do
        auth.merge! info: { email: 'non_registered@example.com',
                            name: 'John Doe' }
      end

      it { expect(call).to be_a_new(User) }
      it { expect(call.name).to eq 'John Doe' }
      it { expect(call.email).to eq 'non_registered@example.com' }
      it { expect(call.provider).to eq auth.provider }
      it { expect(call.uid).to eq auth.uid }
    end
  end

  describe '#save' do
    before do
      user.provider = 'facebook'
      user.uid = 'user_uid'
      user.save!
    end

    it { expect(user.authorizations.first.provider).to eq 'facebook' }
    it { expect(user.authorizations.first.uid).to eq 'user_uid' }
  end
end
