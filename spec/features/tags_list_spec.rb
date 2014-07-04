require_relative 'features_helper'

feature 'List of tags' do
  given!(:tags) { create_list(:tag, 2) }

  scenario 'User can view a list of tags' do
    visit root_path
    click_link 'Tags'
    expect(page).to have_link tags[0].name
    expect(page).to have_link tags[1].name
  end
end
