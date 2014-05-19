require_relative 'features_helper'

feature 'Viewing question' do
  given!(:topic) { create(:topic_with_answers) }

  scenario 'User can view questions with answers to it' do
    visit question_path(topic)
    
    expect(page).to have_content topic.title
    expect(page).to have_content topic.question.body
    topic.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
