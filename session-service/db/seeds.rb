User.create(login: 'user', password: 'user', user_uid: SecureRandom.uuid, role: 'user')

User.create(login: 'admin', password: 'admin', user_uid: SecureRandom.uuid, role: 'admin')
