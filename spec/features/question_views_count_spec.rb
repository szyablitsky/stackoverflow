require_relative 'features_helper'

feature 'Question views count' do
  given(:question) { create(:topic) }

  scenario "question's views count increments with every visit" do
    visit question_path(question)
    expect(page).to have_text(/(viewed)(1 time)/)
    visit root_path
    visit question_path(question)
    expect(page).to have_text(/(viewed)(2 times)/)
  end
end