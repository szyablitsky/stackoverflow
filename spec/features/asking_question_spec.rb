require_relative 'features_helper'

feature 'Asking question' do
  context 'when signed in' do
    background { login_user }

    before do
      visit '/'
      click_link 'Ask question'

      fill_in 'Title', with: 'Some question title'
      fill_in 'Body', with: 'The body of question'
    end

    scenario 'user can add a question' do
      click_button 'Post your question'

      expect(page).to have_content 'Some question title'
      expect(page).to have_content 'The body of question'
    end

    scenario 'user can attach files to question', js: true do
      click_link 'add file'
      attach_file 'File', 'spec/spec_helper.rb'
      # click_link 'add file'
      # attach_file 'File', 'spec/features/features_helper.rb'

      click_button 'Post your question'

      expect(page).to have_link 'spec_helper.rb'
      # expect(page).to have_link 'feature_helper.rb'
    end
  end

  context 'when not signed in' do
    scenario 'user redirected to login form' do
      visit '/'
      click_link 'Ask question'

      expect(page).to have_content 'You need to sign in'
    end
  end
end
