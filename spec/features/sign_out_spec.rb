require 'spec_helper'

feature 'Sign out' do
  context 'when signed in' do
    background { user_signed_in }

    scenario 'user can sign out' do
      visit '/'
      click_link 'Sign out'

      expect(page).not_to have_link 'Sign out'
      expect(page).to have_link 'Sign in'
      expect(page).to have_link 'Sign up'
    end
  end

  context 'when not signed in' do
    scenario 'user can not sign out' do
      visit '/'

      expect(page).not_to have_link 'Sign out'
    end
  end
end
