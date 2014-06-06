# RSpec matcher to spec delegations.
#
# Usage:
#
#   describe Post do
#     it { is_expected.to delegate(:name).to(:author).with_prefix } # post.author_name
#     it { is_expected.to delegate(:month).to(:created_at) }
#     it { is_expected.to delegate(:year).to(:created_at) }
#   end
 
RSpec::Matchers.define :delegate do |method|
  match do |delegator|
    @method = @prefix ? :"#{@to}_#{method}" : method
    param = @method =~ /=^/ ? 1 : nil
    @delegator = delegator
    begin
      @delegator.send(@to)
    rescue NoMethodError
      raise "#{@delegator} does not respond to #{@to}!" 
    end
    allow(@delegator).to receive(@to).and_return double('receiver')
    allow(@delegator.send(@to)).to receive(method).with(param).and_return :called
    @delegator.send(@method, param) == param || :called
  end
 
  description do
    "delegate :#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end

  def message(negated = false)
    "expected #{@delegator} #{negated ? 'not ' : ''}to delegate " +
    ":#{@method} to its #{@to}#{@prefix ? ' with prefix' : ''}"
  end
 
  failure_message do |text|
    message
  end
 
  failure_message_when_negated do |text|
    message true
  end
 
  chain(:to) { |receiver| @to = receiver }
  chain(:with_prefix) { @prefix = true }
end
