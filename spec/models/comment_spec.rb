require 'spec_helper'

describe Comment do
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to belong_to(:message).counter_cache(true) }
end
