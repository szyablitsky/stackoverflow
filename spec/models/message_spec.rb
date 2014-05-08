require 'spec_helper'

describe Message do
  it { expect(subject).to belong_to :topic }
  it { expect(subject).to validate_presence_of :body }
end
