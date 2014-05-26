require 'spec_helper'

describe Attachment, type: :model do
  it { expect(subject).to belong_to :message }
end
