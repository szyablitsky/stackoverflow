require 'spec_helper'

RSpec.describe 'Answers API' do
  let!(:topic) { create :topic }
  let(:user) { create :user }
  let(:token) { create :access_token, resource_owner_id: user.id }

  describe 'answers list' do
    def do_request(options = {})
      get "/api/v1/questions/#{topic.id}/answers",
          { format: :json }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      let!(:messages) { create_list :answer, 2, topic: topic, author: user }
      let(:message) { messages.last }

      before { do_request(access_token: token.token) }

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns an array of 2 objects' do
        expect_json_size 2, 'answers'
      end

      %w(id body created_at updated_at).each do |attribute|
        it "returns #{attribute} for answer" do
          json_val = message.send(attribute.to_sym).to_json
          expect_json_val json_val, "answers/0/#{attribute}"
        end
      end

      %w(id name).each do |attribute|
        it "returns author's #{attribute} for answer" do
          json_val = message.author.send(attribute.to_sym).to_json
          expect_json_val json_val, "answers/0/author/#{attribute}"
        end
      end
    end
  end

  describe 'answer' do
    let!(:message) { create :answer, topic: topic, author: user }

    def do_request(options = {})
      get "/api/v1/questions/#{topic.id}/answers/#{message.id}",
          { format: :json }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      def answer_request
        do_request(access_token: token.token)
      end

      context 'general specs' do
        before { answer_request }

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        %w(id body created_at updated_at).each do |attribute|
          it "returns #{attribute} for answer" do
            json_val = message.send(attribute.to_sym).to_json
            expect_json_val json_val, "answer/#{attribute}"
          end
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for answer" do
            json_val = message.author.send(attribute.to_sym).to_json
            expect_json_val json_val, "answer/author/#{attribute}"
          end
        end
      end

      context 'attachments' do
        let(:attachments) { create_list :attachment, 2, message: message }
        let!(:attachment) { attachments.first }

        before { answer_request }

        it 'returns an array of 2 objects' do
          expect_json_size 2, 'answer/attachments'
        end

        it 'returns url for attachment' do
          json_val = attachment.file.url.to_json
          expect_json_val json_val, 'answer/attachments/0'
        end
      end

      context 'comments' do
        let(:comments) { create_list :comment, 2, message: message, author: user }
        let!(:comment) { comments.first }
        
        before { answer_request }

        it 'returns an array of 2 objects' do
          expect_json_size 2, 'answer/comments'
        end

        %w(id body created_at updated_at).each do |attribute|
          it "returns #{attribute} for comment" do
            json_val = comment.send(attribute.to_sym).to_json
            expect_json_val json_val, "answer/comments/0/#{attribute}"
          end
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for comment" do
            json_val = comment.author.send(attribute.to_sym).to_json
            expect_json_val json_val, "answer/comments/0/author/#{attribute}"
          end
        end
      end
    end
  end

  describe 'post new answer' do
    let(:message) { attributes_for(:answer) }

    def do_request(options = {})
      post "/api/v1/questions/#{topic.id}/answers",
           { format: :json, message: message }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      def answer_request
        do_request(access_token: token.token)
      end

      it 'creates new message' do
        expect { answer_request }.to change(Message, :count).by(1)
      end

      describe 'attributes' do
        before { answer_request }

        it "sets answer's body" do
          expect(Message.last.body).to eq message[:body]
        end

        it "sets answer's topic" do
          expect(Message.last.topic).to eq topic
        end

        it "sets answer's author" do
          expect(Message.last.author).to eq user
        end

        it "returns answer's id" do
          expect_json_val Message.last.id.to_json, 'answer/id'
        end

        it "returns answer's body" do
          expect_json_val message[:body].to_json, 'answer/body'
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for answer" do
            json_val = user.send(attribute.to_sym).to_json
            expect_json_val json_val, "answer/author/#{attribute}"
          end
        end
      end

      context 'already answered by user' do
        before do
          create :answer, topic: topic, author: user
          answer_request
        end

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end
      end
    end
  end
end
