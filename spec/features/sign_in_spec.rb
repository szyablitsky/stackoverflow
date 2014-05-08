require 'spec_helper'

feature 'Sign in' do
  given(:user) { create(:user) }

  scenario 'User can sign in with valid email and password' do
    sign_in user

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'User can not sign in with invalid email or password' do
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: 'invalid-password'
    click_button 'Sign in'

    expect(page).to have_content 'Invalid email or password.'
  end
end
