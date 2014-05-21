require_relative 'features_helper'

feature 'Viewing user profile' do
  given(:user) { create(:user, reputation: 38_492) }

  scenario 'User can see information about registered user' do
    visit user_path(user)

    expect(page).to have_text user.name
    expect(page).to have_text user.reputation.to_s
  end

  scenario 'Signeg in user can see information about himself' do
    login user
    click_link user.name

    expect(page).to have_text user.name
    expect(page).to have_text user.reputation.to_s
  end
end
