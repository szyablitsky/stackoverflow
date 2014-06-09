require_relative 'features_helper'

feature 'Editing answer', 'Signed in user can edit his answer' do
  given(:topic) { create :topic }
  given(:answer) { create :answer, topic: topic }

  context 'when signed in' do
    given(:user) { create :user }

    background { answer.update_attribute :author, user }

    context 'and seeing his own answer' do
      background { login user }

      def edit_answer
        visit question_path(topic)
        within('#answers') { click_link 'edit' }
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save changes'
      end

      scenario 'user can edit answer' do
        edit_answer

        expect(current_path).to eq(question_path(topic))
        expect(page).to have_content 'edited answer'
      end
    end

    context "and seeing other user's answer" do
      given(:other_user) { create :user }

      background { login other_user }

      scenario 'user should not see edit answer link' do
        visit question_path(topic)

        expect(page).to_not have_link 'edit'
      end
    end
  end

  context 'when not signed in' do
    scenario 'user should not see edit answer link' do
      visit question_path(topic)

      expect(page).to_not have_link 'edit'
    end
  end
end
