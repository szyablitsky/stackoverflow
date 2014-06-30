require 'spec_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :message }
  it { is_expected.to belong_to :user }
end
