class Privilege
  @@privileges = {
    create_comment: 50
  }

  def self.method_missing(symbol)
    @@privileges[symbol] ? @@privileges[symbol] : 100000000
  end
end