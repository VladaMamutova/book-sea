class AuthenticateUser
  prepend SimpleCommand

  def initialize(login, password)
    @login = login
    @password = password
  end

  def call
    authenticated_user = user
    return unless authenticated_user

    token = JsonWebToken.encode(user_uid: authenticated_user.user_uid, role: authenticated_user.role)
    { token: token, role: authenticated_user.role }
  end

  private

  attr_accessor :login, :password

  def user
    user = User.find_by(login: login)
    # The authenticate method can be available by putting
    # has_secure_password in the User model
    # to check if the user's password is correct.
    return user if user.present? && user.authenticate(password) # user or nil

    errors.add :message, 'Invalid login or password'
    nil
  end
end
