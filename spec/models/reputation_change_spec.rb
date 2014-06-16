require 'spec_helper'

RSpec.describe ReputationChange, type: :model do
  it { is_expected.to belong_to :message }
  it { is_expected.to belong_to(:receiver).class_name('User') }
  it { is_expected.to belong_to(:committer).class_name('User') }
  it { is_expected.to validate_numericality_of :amount }

  describe '#create' do
    let(:amount) { 15 }
    let(:user) { create :user }

    before do
      subject.amount = amount
      subject.receiver = user
    end

    it "should change receiver's reputation by amount" do
      expect { subject.save }.to change { user.reputation }.by(amount)
    end
  end
end
