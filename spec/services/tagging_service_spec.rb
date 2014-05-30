require 'spec_helper'

describe TaggingService do
  describe '.process' do
    let(:topic) { build(:topic) }
    let(:tags_string) { 'tag1,tag2' }
    let!(:tag1) { create(:tag, name: 'tag1') }

    def process_tags
      TaggingService.process tags_string, for: topic
    end

    it 'should add existing tag to topic' do
      process_tags
      expect(topic.tags).to include(tag1)
    end

    it 'should create new tag' do
      expect { process_tags }.to change(Tag, :count).by(1)
    end

    it 'should add new tag to topic' do
      process_tags
      expect(topic.tags.map(&:name)).to include('tag2')
    end
  end
end
