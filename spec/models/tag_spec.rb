require 'spec_helper'

describe Tag, type: :model do
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to have_many(:topic_tags) }
  it { expect(subject).to have_many(:topics).through(:topic_tags) }
end
