require 'spec_helper'

feature 'Sign in' do
  scenario 'User can sign in with valid email and password' do
    create(:user)

    visit new_user_session_path
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345678'
    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'User can not sign in with invalid email or password' do
    visit new_user_session_path
    click_button 'Sign in'

    expect(page).to have_content 'Invalid email or password.'
  end
end
