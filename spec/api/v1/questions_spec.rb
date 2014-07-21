require 'spec_helper'

RSpec.describe 'Questions API' do
  describe 'questions' do
    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      let(:topics) { create_list :topic, 2 }
      let(:topic) { topics.first }
      let(:token) { create :access_token }
      let(:user) { create :user }

      before do
        topic.update_attribute :author, user
        do_request access_token: token.token
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'returns an array of 2 objects' do
        expect_json_size 2, 'questions'
      end

      %w(id title created_at updated_at).each do |attribute|
        it "returns #{attribute} for question" do
          json_val = topic.send(attribute.to_sym).to_json
          expect_json_val json_val, "questions/0/#{attribute}"
        end
      end

      it 'returns body for question' do
        topics.each_with_index do |topic, i|
          json_val = topic.question.body.to_json
          expect_json_val json_val, 'questions/0/body'
        end
      end

      %w(id name).each do |attribute|
        it "returns author's #{attribute} for question" do
          json_val = topic.question.author.send(attribute.to_sym).to_json
          expect_json_val json_val, "questions/0/author/#{attribute}"
        end
      end
    end
  end

  describe 'question' do
    let!(:topic) { create :topic }

    def do_request(options = {})
      get "/api/v1/questions/#{topic.id}", { format: :json }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      let(:token) { create :access_token }

      def question_request
        do_request(access_token: token.token)
      end

      context 'general specs' do
        before { question_request }

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        %w(id title created_at updated_at).each do |attribute|
          it "returns question's #{attribute}" do
            json_val = topic.send(attribute.to_sym).to_json
            expect_json_val json_val, "question/#{attribute}"
          end
        end

        it "returns question's body" do
          json_val = topic.question.body.to_json
          expect_json_val json_val, 'question/body'
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for question" do
            json_val = topic.question.author.send(attribute.to_sym).to_json
            expect_json_val json_val, "question/author/#{attribute}"
          end
        end
      end

      context 'attachments' do
        let(:attachments) { create_list :attachment, 2, message: topic.question }
        let!(:attachment) { attachments.first }

        before { question_request }

        it 'returns an array of 2 objects' do
          expect_json_size 2, 'question/attachments'
        end

        it 'returns url for attachment' do
          json_val = attachment.file.url.to_json
          expect_json_val json_val, 'question/attachments/0'
        end
      end

      context 'comments' do
        let(:user) { create :user }
        let(:comments) { create_list :comment, 2, message: topic.question, author: user }
        let!(:comment) { comments.first }
        
        before { question_request }

        it 'returns an array of 2 objects' do
          expect_json_size 2, 'question/comments'
        end

        %w(id body created_at updated_at).each do |attribute|
          it "returns #{attribute} for comment" do
            json_val = comment.send(attribute.to_sym).to_json
            expect_json_val json_val, "question/comments/0/#{attribute}"
          end
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for comment" do
            json_val = comment.author.send(attribute.to_sym).to_json
            expect_json_val json_val, "question/comments/0/author/#{attribute}"
          end
        end
      end

      context 'tags' do
        let(:tags) { create_list :tag, 2 }
        let(:tag) { tags.first }
        
        before do
          topic.tags << tags
          question_request
        end

        it 'returns an array of 2 objects' do
          expect_json_size 2, 'question/tags'
        end

        it 'returns name for tag' do
          json_val = tag.name.to_json
          expect_json_val json_val, 'question/tags/0'
        end
      end
    end
  end

  describe 'post new question' do
    let(:topic) do
      attributes_for(:topic)
        .merge(question_attributes: attributes_for(:question))
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json, topic: topic }.merge(options)
    end

    it_behaves_like 'prevents unauthorized access'

    context 'when authorized' do
      let(:user) { create :user }
      let(:token) { create :access_token, resource_owner_id: user.id }

      def question_request
        do_request(access_token: token.token)
      end

      it 'creates new topic' do
        expect { question_request }.to change(Topic, :count).by(1)
      end

      it 'creates new message' do
        expect { question_request }.to change(Message, :count).by(1)
      end

      describe 'attributes' do
        before { question_request }

        it 'sets topic title' do
          expect(Topic.first.title).to eq topic[:title]
        end

        it 'sets question body' do
          expect(Topic.first.question.body)
            .to eq topic[:question_attributes][:body]
        end

        it 'sets question author' do
          expect(Topic.first.question.author).to eq user
        end

        it "returns question's id" do
          json_val = Topic.first.id.to_json
          expect_json_val json_val, 'question/id'
        end

        it "returns question's title" do
          json_val = topic[:title].to_json
          expect_json_val json_val, 'question/title'
        end

        it "returns question's body" do
          json_val = topic[:question_attributes][:body].to_json
          expect_json_val json_val, 'question/body'
        end

        %w(id name).each do |attribute|
          it "returns author's #{attribute} for question" do
            json_val = user.send(attribute.to_sym).to_json
            expect_json_val json_val, "question/author/#{attribute}"
          end
        end
      end

      describe 'tags' do
        before { topic.merge! tags: 'tag1,tag2' }

        it 'creates tags' do
          expect { question_request }.to change(Tag, :count).by(2)
        end

        describe 'misc' do
          before { question_request }

          it 'links tags to topic' do
            expect(Topic.first.tags.size).to eq 2
          end

          it 'returns an array of 2 tags' do
            expect_json_size 2, 'question/tags'
          end

          it 'returns name for tag' do
            expect_json_val 'tag1'.to_json, 'question/tags/0'
          end
        end
      end
    end
  end
end
