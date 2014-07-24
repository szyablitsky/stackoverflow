require_relative 'features_helper'

feature 'Answers subscription',
  'Signed in user can subscribe for new answers' do
  given(:topic) { create :topic }

  context 'when signed in' do
    given(:user) { create :user }

    background { login user }

    scenario 'user can subscribe for new answers', js: true do
      visit question_path(topic)
      click_link 'subscribe'

      expect(page).to have_link 'unsubscribe'
      expect(page).not_to have_link(/\bsubscribe/)
    end

    context 'and already subscribed' do
      before { create :subscription, topic: topic, user: user }

      scenario 'user can unsubscribe', js: true do
        visit question_path(topic)
        click_link 'unsubscribe'

        expect(page).to have_link 'subscribe'
        expect(page).not_to have_link 'unsubscribe'
      end
    end
  end

  context 'when not signed in' do
    scenario 'user should not see edit subscribe link' do
      visit question_path(topic)

      expect(page).to_not have_link 'subscribe'
    end
  end
end
