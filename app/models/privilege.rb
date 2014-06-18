class Privilege
  PRIVILEGES = {
    create_comment: 50
  }

  def self.allowed(action, options)
    user = options[:for]
    user.reputation >= PRIVILEGES[action]
  end

  def self.method_missing(symbol)
    return PRIVILEGES[symbol] if PRIVILEGES.key? symbol
    super
  end

  def self.respond_to?(symbol)
    return true if PRIVILEGES.key?(symbol)
    super
  end
end