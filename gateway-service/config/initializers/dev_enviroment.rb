unless Rails.env.production?
  ENV['SESSION_SECRET_KEY'] = '7ff6d05ca7a667432624798a905b65ff655b284a52911baed11a2057f228d364ee0e0ebf2cdebe8094f21a0b178af28e5809477d499e54e1feac0f7b3e2d2d72'
end
