require 'spec_helper'

describe TopicTag, type: :model do
  it { is_expected.to belong_to :topic }
  it { is_expected.to belong_to :tag }
end
