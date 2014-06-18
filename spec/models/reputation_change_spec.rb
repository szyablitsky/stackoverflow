require 'spec_helper'

RSpec.describe ReputationChange, type: :model do
  it { is_expected.to belong_to :message }
  it { is_expected.to belong_to(:receiver).class_name('User') }
  it { is_expected.to belong_to(:committer).class_name('User') }
  it { is_expected.to validate_numericality_of :amount }
end
