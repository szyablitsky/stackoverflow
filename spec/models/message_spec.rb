require 'spec_helper'

describe Message do
  it { expect(subject).to belong_to :topic }
end
