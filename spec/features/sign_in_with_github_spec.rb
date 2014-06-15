require_relative 'features_helper'

feature 'Sign in with GitHub account' do
  let(:user) { create :user }

  def valid_credentials(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'github', uid: '123545',
      info: { name: user[:name], email: user[:email] },
      extra: { raw_info: { name: user[:name], email: user[:email] } }
    })
  end

  before { visit new_user_session_path }

  context 'already registered' do
    scenario 'user can sign in with valid credentials' do
      valid_credentials user
      click_link 'Sign in with Github'

      expect(page).to have_content 'Successfully authenticated from Github'
    end
  end

  context 'not registered' do
    scenario 'user can sign in with valid credentials' do
      valid_credentials name: 'John Doe', email: 'john@doe.com'
      click_link 'Sign in with Github'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'

      expect(page).to have_content 'You have signed up successfully'
    end
  end

  scenario 'user can not login with invalid credentials' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    silence_omniauth { click_link 'Sign in with Github' }

    expect(page).to have_content 'Could not authenticate you from GitHub'
  end
end
