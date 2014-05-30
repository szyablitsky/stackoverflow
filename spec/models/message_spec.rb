require 'spec_helper'

describe Message do
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to belong_to(:topic).counter_cache(true) }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :attachments }

  it { is_expected.to accept_nested_attributes_for :attachments }

  it { is_expected.to validate_presence_of :body }

  describe '#has_attachments?' do
    context 'when attachments exist' do
      before do
        subject.body = 'body'
        subject.save!
        subject.attachments.create
        subject.reload
      end

      it { expect(subject.has_attachments?).to be true }
    end

    context 'when no attachments exist' do
      it { expect(subject.has_attachments?).to be false }
    end
  end

  describe '#has_comments?' do
    context 'when comments exist' do
      before do
        subject.body = 'body'
        subject.save!
        subject.comments.create(body: 'comment')
        subject.reload
      end
      
      it { expect(subject.has_comments?).to be true }
    end

    context 'when no comments exist' do
      it { expect(subject.has_comments?).to be false }
    end
  end
end
