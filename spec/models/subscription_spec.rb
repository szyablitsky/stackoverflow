require 'spec_helper'

RSpec.describe Subscription, :type => :model do
  it { is_expected.to belong_to :topic }
  it { is_expected.to belong_to :user }
end
