require_relative 'features_helper'

feature 'Editing user profile' do
  given(:user1) { create(:user, name: 'test_user') }
  given(:user2) { create(:user) }

  context 'when logged in' do
    before { login user1 }

    scenario "user can't see edit link on other user's profile" do
      visit user_path(user2)

      expect(page).to_not have_link 'edit profile'
    end

    scenario 'user can edit his profile' do
      visit user_path(user1)
      click_link 'edit profile'

      fill_in 'Name', with: 'edited_user'
      click_button 'Save profile'

      expect(page).to have_text 'edited_user'
    end
  end

  context 'when not logged in' do
    scenario "user can't see edit link on user's profile" do
      visit user_path(user1)

      expect(page).to_not have_link 'edit profile'
    end
  end
end
