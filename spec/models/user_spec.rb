require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  it { is_expected.to have_many(:messages).with_foreign_key('author_id') }
  it { is_expected.to have_many(:comments).with_foreign_key('author_id') }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
