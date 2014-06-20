require 'spec_helper'

RSpec.describe Attachment, type: :model do
  it { is_expected.to belong_to(:message).counter_cache(true) }
end
