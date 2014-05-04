require 'spec_helper'

describe Topic do
  it { expect(subject).to validate_presence_of :title }
  it { expect(subject).to have_one(:question).class_name('Message').conditions(answer: false) }
  it { expect(subject).to have_many(:answers).class_name('Message').conditions(answer: true) }
end
