require_relative 'features_helper'

feature 'List of questions' do
  given!(:topics) { create_list(:topic, 2) }

  scenario 'User can view a list of questions' do
    visit '/'
    expect(page).to have_content topics[0].title
    expect(page).to have_content topics[1].title
  end
end
