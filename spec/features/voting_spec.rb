require_relative 'features_helper'

feature 'Voting' do
  let(:topic) { create :topic }
  let!(:answer) { create :answer, topic: topic }
  let(:user) { create :user }

  def expectations(message)
    visit question_path(topic)
    within "#message-#{id}" do
      find("a.vote-#{direction}").click
      expect(page).to have_content message
      expect(find('.score').text).to eq '0'
    end
  end

  shared_examples_for 'voting' do
    context 'and has enough reputation' do
      background { user.update_attribute(:reputation, reputation) }

      scenario 'changes message score', js: true do
        visit question_path(topic)
        within "#message-#{id}" do
          find("a.vote-#{direction}").click
          expect(find('.score')).to have_text '1'
        end
      end

      context 'but already voted for this message' do
        background do
          create :vote, message: message, user: user
        end

        scenario "can't vote message", js: true do
          expectations "You already voted for this #{message_type}"
        end
      end

      context 'and is an author of message' do
        background do
          message.update_attribute :author, user
        end

        scenario "can't vote message", js: true do
          expectations "You can not vote for your own #{message_type}"
        end
      end
    end

    context 'and has low reputation' do
      scenario "can't vote message", js: true do
        expectations "You must have #{reputation} reputation to vote #{direction}"
      end
    end
  end

  context 'Signed in user' do
    background { login user }

    context 'voting up' do
      let(:direction) { 'up' }
      let(:reputation) { Privilege.voteup }

      context 'for question' do
        let(:id) { topic.question.id }
        let(:message) { topic.question }
        let(:message_type) { 'question' }

        it_behaves_like 'voting'
      end

      context 'for answer' do
        let(:id) { answer.id }
        let(:message) { answer }
        let(:message_type) { 'answer' }

        it_behaves_like 'voting'
      end
    end

    context 'voting down' do
      let(:direction) { 'down' }
      let(:reputation) { Privilege.votedown }

      context 'for question' do
        let(:id) { topic.question.id }
        let(:message) { topic.question }
        let(:message_type) { 'question' }

        it_behaves_like 'voting'
      end

      context 'for answer' do
        let(:id) { answer.id }
        let(:message) { answer }
        let(:message_type) { 'answer' }

        it_behaves_like 'voting'
      end
    end
  end

  context 'Guest' do
    let(:tooltip_text) { 'You have to sign in or sign up to vote' }

    context 'voting up' do
      let(:direction) { 'up' }

      context 'for question' do
        let(:id) { topic.question.id }
        scenario "can't vote", js: true do expectations tooltip_text end
      end

      context 'for answer' do
        let(:id) { answer.id }
        scenario "can't vote", js: true do expectations tooltip_text end
      end
    end

    context 'voting down' do
      let(:direction) { 'down' }

      context 'for question' do
        let(:id) { topic.question.id }
        scenario "can't vote", js: true do expectations tooltip_text end
      end

      context 'for answer' do
        let(:id) { answer.id }
        scenario "can't vote", js: true do expectations tooltip_text end
      end
    end
  end
end
