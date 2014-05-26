class Privilege
  PRIVILEGES = {
    create_comment: 50
  }

  def self.method_missing(symbol)
    PRIVILEGES.key?(symbol) ? PRIVILEGES[symbol] : 1_000_000_000
  end

  def self.respond_to?(symbol)
    PRIVILEGES.key?(symbol)
  end
end