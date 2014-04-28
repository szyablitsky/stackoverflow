require 'spec_helper'

describe Topic do
  it { should validate_presence_of :title }
end
