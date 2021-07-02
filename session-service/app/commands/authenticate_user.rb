class AuthenticateUser
  prepend SimpleCommand

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    token = JsonWebToken.encode(user_uid: user.user_uid, role: user.role) if user
    return { token: token, role: user.role }
  end

  private

  attr_accessor :login, :password

  def user
    user = User.find_by(login: login)
    # The authenticate method can be available by putting
    # has_secure_password in the User model
    # to check if the user's password is correct.
    return user if user&.authenticate(password) # user or nil

    errors.add :message, 'Invalid login or password'
    nil
  end
end
