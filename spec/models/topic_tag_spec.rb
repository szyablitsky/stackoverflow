require 'spec_helper'

describe TopicTag, type: :model do
  it { expect(subject).to belong_to :topic }
  it { expect(subject).to belong_to :tag }
end
