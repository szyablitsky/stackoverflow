require_relative 'features_helper'

feature 'Sign up' do
  scenario 'User can sign up with email and password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome!'
  end

  scenario 'User can not sign up without email or password' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_content 'error'
  end

  scenario 'User can not sign up when password and confirmation does not match' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password2'
    click_button 'Sign up'

    expect(page).to have_content(/error.+match/)
  end
end
