require 'spec_helper'

describe Tag, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many(:topic_tags) }
  it { is_expected.to have_many(:topics).through(:topic_tags) }
end
