unless Rails.env.production?
  ENV['RABBITMQ_USERNAME'] = 'quest'
  ENV['RABBITMQ_PASSWORD'] = 'guest'
end
