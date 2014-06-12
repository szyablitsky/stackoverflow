class Privilege
  PRIVILEGES = {
    create_comment: 50
  }

  def self.allowed(action, options)
    user = options[:for]
    user.reputation >= PRIVILEGES[action]
  end

  def self.method_missing(symbol)
    PRIVILEGES.key?(symbol) ? PRIVILEGES[symbol] : 1_000_000_000
  end

  def self.respond_to?(symbol)
    PRIVILEGES.key?(symbol)
  end
end