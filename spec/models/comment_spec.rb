require 'spec_helper'

describe Comment do
  it { expect(subject).to validate_presence_of :body }
  it { expect(subject).to belong_to(:author).class_name('User') }
  it { expect(subject).to belong_to(:message) }
end
