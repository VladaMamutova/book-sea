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
  },
  {
    name: 'Библиотека-читальня им. И.С. Тургенева',
    address: 'Бобров пер., 6, стр. 1'
  },
  {
    name: 'Российская государственная библиотека',
    address: 'ул. Воздвиженка, 3/5'
  }
]

moscow = City.find_by!(name: 'Москва')
moscow_libraries.each do |library|
  moscow.libraries.create(
    name: library[:name],
    library_uid: SecureRandom.uuid,
    address: library[:address]
  )
end

saint_petersburg = City.find_by!(name: 'Санкт-Петербург')
saint_peterburg.libraries.create(
  name: 'Российская национальная библиотека',
  library_uid: SecureRandom.uuid,
  address: 'ул. Садовая, 18'
)

saint_petersburg.libraries.create(
  name: 'Библиотека Маяковского',
  library_uid: SecureRandom.uuid,
  address: 'набережная реки Фонтанки, 44'
)

City.find_by!(name: 'Казань').libraries.create(
  name: 'Центральная Городская Библиотека',
  library_uid: SecureRandom.uuid,
  address: 'ул. Вишневского, 10'
)
