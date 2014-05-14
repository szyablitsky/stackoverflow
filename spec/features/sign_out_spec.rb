require_relative 'features_helper'

feature 'Sign out' do
  context 'when signed in' do
    given(:user) { create(:user) }

    scenario 'user can sign out' do
      sign_in user

      visit '/'
      click_link 'Sign out'

      expect(page).not_to have_text 'Signed in as'
      expect(page).not_to have_link 'Sign out'
    end
  end

  context 'when not signed in' do
    scenario 'user can not sign out' do
      visit '/'

      expect(page).not_to have_link 'Sign out'
    end
  end
end
