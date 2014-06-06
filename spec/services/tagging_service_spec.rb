require 'spec_helper'

describe TaggingService do
  describe '.process' do
    let(:tag_to_delete) { create(:tag, name: 'tag3') }
    let!(:topic) { build(:topic, tags: [tag_to_delete]) }
    let(:tags_string) { 'tag1,tag2' }
    let!(:existing_tag) { create(:tag, name: 'tag1') }

    def process_tags
      TaggingService.process tags_string, for: topic
    end

    it 'should add existing tag to topic' do
      process_tags
      expect(topic.tags).to include(existing_tag)
    end

    it 'should create new tag' do
      expect { process_tags }.to change(Tag, :count).by(1)
    end

    it 'should add new tag to topic' do
      process_tags
      expect(topic.tags.map(&:name)).to include('tag2')
    end

    it 'should remove unspecified tag from topic' do
      process_tags
      expect(topic.tags.map(&:name)).to_not include('tag3')
    end
  end
end
