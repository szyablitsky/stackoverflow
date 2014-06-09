require_relative 'features_helper'

feature 'Editing question', 'Signed in user can edit his question' do
  given(:topic) { create :topic }

  context 'when signed in' do
    given(:user) { create :user }

    background { topic.update_attribute :author, user }

    context 'and seeing his own question' do
      background { login user }

      def edit_question
        visit question_path(topic)
        click_link 'edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save changes'
      end

      scenario 'user can edit question' do
        edit_question

        expect(current_path).to eq(question_path(topic))
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
      end
    end

    context "and seeing other user's question" do
      given(:other_user) { create :user }

      background { login other_user }

      scenario 'user should not see edit question link' do
        visit question_path(topic)

        expect(page).to_not have_link 'edit'
      end
    end
  end

  context 'when not signed in' do
    scenario 'user should not see edit question link' do
      visit question_path(topic)

      expect(page).to_not have_link 'edit'
    end
  end
end
