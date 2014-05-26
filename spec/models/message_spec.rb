require 'spec_helper'

describe Message do
  it { expect(subject).to belong_to(:author).class_name('User') }
  it { expect(subject).to belong_to :topic }
  it { expect(subject).to have_many :comments }
  it { expect(subject).to have_many :attachments }

  it { expect(subject).to accept_nested_attributes_for :attachments }

  it { expect(subject).to validate_presence_of :body }

  describe '#has_attachments?' do
    context 'when attachments exist' do
      before do
        subject.body = 'body'
        subject.save!
        subject.attachments.create
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
      end
      
      it { expect(subject.has_comments?).to be true }
    end

    context 'when no comments exist' do
      it { expect(subject.has_comments?).to be false }
    end
  end
end
