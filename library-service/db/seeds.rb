# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

cities = ['Москва', 'Санкт-Петербург', 'Казань', 'Екатеринбург', 'Нижний Новгород']
cities.each { |city| City.create(name: city) }

moscow_libraries = [
  {
    name: 'Центральная универсальная научная библиотека им. Н.А. Некрасова',
    address: 'ул. Бауманская, 58/25, стр. 14'
  },
  {
    name: 'Библиотека-читальня имени А. С. Пушкина',
    address: 'ул. Спартаковская, 9'
  },
  {
    name: 'Библиотека им. Ф.М. Достоевского',
    address: 'б-р Чистопрудный, 23, стр. 1'
  }
]

moscow_libraries.each do |library|
  City.find_by!(name: 'Москва').libraries.create(
    name: library[:name],
    library_uid: SecureRandom.uuid,
    address: library[:address]
  )
end

City.find_by!(name: 'Санкт-Петербург').libraries.create(
  name: 'Российская национальная библиотека',
  library_uid: SecureRandom.uuid,
  address: 'ул. Садовая, 18'
)
