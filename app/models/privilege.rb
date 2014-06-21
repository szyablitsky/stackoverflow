class Privilege
  PRIVILEGES = {
    create_comment: 50
  }

  def self.method_missing(symbol)
    return PRIVILEGES[symbol] if PRIVILEGES.key? symbol
    super
  end

  def self.respond_to?(symbol)
    return true if PRIVILEGES.key?(symbol)
    super
  end
end