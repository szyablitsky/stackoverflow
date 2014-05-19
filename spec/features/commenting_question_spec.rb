require_relative 'features_helper'

feature 'Commenting question' do
  given(:question) { create(:topic) }

  context 'when signed in' do
    given(:user) { create(:user) }

    before { login user }

    context 'user with reputation 50 or more' do
      before do
        user.reputation = 50
        user.save!
      end

      scenario 'should be able to add comment', js: true do
        visit question_path(question)

        within '.question' do
          click_link 'add comment'
          fill_in 'comment_body', with: 'my comment'
          click_button 'Post your comment'

          expect(page).to have_text 'my comment'
          expect(page).to_not have_field 'comment_body'
        end
      end

      scenario 'should be able to cancel adding comment', js: true do
        visit question_path(question)

        within '.question' do
          click_link 'add comment'
          click_button 'Cancel'

          expect(page).to_not have_field 'comment_body'
          expect(page).to_not have_button 'Post your comment'
        end
      end
    end

    context 'user with reputation less than 50', js: true do
      scenario 'can not add comment' do
        visit question_path(question)

        within '.question' do
          click_link 'add comment'

          expect(page).to have_text 'You must have 50 reputation to comment'
        end
      end
    end
  end

  context 'when not signed in' do
    scenario 'user should not see add comment link' do
      visit question_path(question)

      expect(page).to_not have_link 'add comment'
    end
  end
end
