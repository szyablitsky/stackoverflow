class Privilege
  @@privileges = {
    create_comment: 50
  }

  def self.method_missing(symbol)
    @@privileges[symbol] ? @@privileges[symbol] : 1_000_000_000
  end
end