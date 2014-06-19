class ReputationChangeDecorator
  def initialize(change)
    @change = change
  end

  def amount_class
    return 'negative' if amount =~ /-/
    return 'accept' if type == '0' && receiver_id != committer_id
    'positive'
  end

  def amount_value
    return "+#{amount}" unless amount =~ /-/
    amount
  end

  def time
    created_at.to_time
  end

  TYPE_STRING = { '0' => 'accept', '1' => 'upvote', '2' => 'downvote' }

  def type_string
    TYPE_STRING[type]
  end

  def method_missing(symbol)
    key = symbol.to_s
    return @change[key] if @change.key? key
    super
  end
end
