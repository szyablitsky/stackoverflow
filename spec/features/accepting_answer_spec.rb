require_relative 'features_helper'

feature 'Accepting answer.',
  'User can accept answer for his own (and only his own) question.' do

  given (:topic) { create :topic_with_answers }
  given (:user) { create :user }
  background { topic.question.update_attribute(:author, user) }

  context 'When signed in' do
    context 'and seeing his own question' do
      given! (:answer) { create :answer, topic: topic, author: user }
      background { login user }

      def accept_answer(try = true)
        visit question_path(topic)
        within("#message-#{answer.id}") do
          click_link 'accept'
          try ? click_on('Accept this answer') : click_on('Cancel')
        end
      end

      scenario 'user can accept answer', js: true do
        accept_answer

        expect(page).to_not have_link 'accept'
        expect(page).to have_selector '.glyphicon-ok'
      end

      scenario 'user can cancel accepting answer', js: true do
        accept_answer false

        expect(page).to have_link 'accept'
        expect(page).to_not have_selector '.glyphicon-ok'
      end

      context 'and answer already accepted' do
        background { answer.update_attribute(:accepted, true) }

        scenario 'user should not see accept answer link' do
          visit question_path(topic)

          expect(page).to_not have_link 'accept'
        end
      end
    end

    context "and seeing other user's question" do
      given(:other_user) { create :user }

      background { login other_user }

      scenario 'user should not see accept answer link' do
        visit question_path(topic)

        expect(page).to_not have_link 'accept'
      end
    end
  end

  context 'When not signed in' do
    scenario 'user should not see edit answer link' do
      visit question_path(topic)

      expect(page).to_not have_link 'accept'
    end
  end
end
