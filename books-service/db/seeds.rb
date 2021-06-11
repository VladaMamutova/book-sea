# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

authors = [
  {
    first_name: 'Александр',
    middle_name: 'Сергеевич',
    last_name: 'Пушкин',
    info: 'Русский поэт, драматург и прозаик, заложивший основы русского
      реалистического направления, литературный критик и теоретик литературы,
      историк, публицист, журналист. Один из самых авторитетных литературных
      деятелей первой трети XIX века.'
  },
  {
    first_name: 'Лев',
    middle_name: 'Николаевич',
    last_name: 'Толстой',
    info: 'Один из наиболее известных русских писателей и мыслителей, один из
      величайших писателей-романистов мира, участник обороны Севастополя,
      просветитель, публицист, религиозный мыслитель. Был номинирован на
      Нобелевскую премию по литературе (1902, 1903, 1904, 1905). Впоследствии
      отказался от дальнейших номинаций. Ещё при жизни был признан главой
      русской литературы.'
  },
  {
    first_name: 'Александр',
    middle_name: nil,
    last_name: 'Дюма',
    info: 'Французский писатель, драматург и журналист, один из самых читаемых
      французских авторов, мастер приключенческого романа. Под именем Дюма вышло
      огромное количество исторических романов, в написании которых участвовали
      литературные подёнщики. Помимо романов, его перу принадлежат также пьесы,
      статьи и книги о путешествиях.'
  },
  {
    first_name: 'Михаил',
    middle_name: 'Юрьевич',
    last_name: 'Лермонтов',
    info: 'Русский поэт, прозаик, драматург, художник. Творчество Лермонтова
      ознаменовало собой новый расцвет русской литературы и оказало большое влияние
      на виднейших русских писателей и поэтов XIX и XX веков. Произведения
      Лермонтова получили большой отклик в живописи, театре, кинематографе.
      Его стихи стали подлинным кладезем для оперного, симфонического и романсового
      творчества. Многие из них стали народными песнями.'
  },
  {
    first_name: 'Фёдор',
    middle_name: 'Иванович',
    last_name: 'Достоевский',
    info: 'Русский писатель, мыслитель, философ и публицист, член-корреспондент
      Петербургской академии наук с 1877 года. Классик мировой литературы, по
      данным ЮНЕСКО, один из самых читаемых писателей в мире. После смерти Достоевский
      был признан классиком русской литературы и одним из лучших романистов мирового з
      начения, считается первым представителем персонализма в России.'
  },
  {
    first_name: 'Эрих',
    middle_name: 'Мария',
    last_name: 'Ремарк',
    info: 'Немецкий писатель XX века, представитель «потерянного поколения».
    Его роман «На Западном фронте без перемен» входит в большую тройку романов
    «потерянного поколения», изданных в 1929 году, наряду с произведениями
    «Прощай, оружие!» Эрнеста Хемингуэя и «Смерть героя» Ричарда Олдингтона.'
  }
]
authors.each do |author|
  Author.create(
    author_uid: SecureRandom.uuid,
    first_name: author[:first_name],
    middle_name: author[:middle_name],
    last_name: author[:last_name],
    info: author[:info]
  )
end

genres = ['роман', 'повесть', 'рассказ', 'новелла', 'роман в стихах', 'сказка']
genres.each { |genre| Genre.create(name: genre) }

novel_id = Genre.find_by(name: 'роман').id
story_id = Genre.find_by(name: 'повесть').id
verse_novel_id = Genre.find_by(name: 'роман в стихах').id
fairy_tale_id = Genre.find_by(name: 'сказка').id

tolstoy_uid = Author.find_by(last_name: 'Толстой').author_uid
dostoevsky_uid = Author.find_by(last_name: 'Достоевский').author_uid
dumas_uid = Author.find_by(last_name: 'Дюма').author_uid
remark_uid = Author.find_by(last_name: 'Ремарк').author_uid
pushkin_uid = Author.find_by(last_name: 'Пушкин').author_uid

books = [
  { name: 'Война и мир',    genre_id: novel_id,   author_uid: tolstoy_uid },
  { name: 'Детство',        genre_id: story_id,   author_uid: tolstoy_uid },
  { name: 'Отрочество',     genre_id: story_id,   author_uid: tolstoy_uid },
  { name: 'Юность',         genre_id: story_id,   author_uid: tolstoy_uid },
  { name: 'Анна Каренина',  genre_id: novel_id,   author_uid: tolstoy_uid },

  { name: 'Преступление и наказание', genre_id: novel_id,   author_uid: dostoevsky_uid },
  { name: 'Идиот',                    genre_id: novel_id,   author_uid: dostoevsky_uid },
  { name: 'Братья Карамазовы',        genre_id: novel_id,   author_uid: dostoevsky_uid },

  { name: 'Королева Марго',     genre_id: novel_id,   author_uid: dumas_uid },
  { name: 'Три мушкетёра',      genre_id: novel_id,   author_uid: dumas_uid },
  { name: 'Граф Монте-Кристо',  genre_id: novel_id,   author_uid: dumas_uid },

  { name: 'Жизнь взаймы',       genre_id: novel_id,   author_uid: remark_uid },
  { name: 'Чёрный обелиск',     genre_id: novel_id,   author_uid: remark_uid },
  { name: 'Три товарища',       genre_id: novel_id,   author_uid: remark_uid },
  { name: 'Триумфальная арка',  genre_id: novel_id,   author_uid: remark_uid },

  { name: 'Евгений Онегин',  genre_id: verse_novel_id,   author_uid: pushkin_uid },
  { name: 'Пиковая дама',  genre_id: story_id,   author_uid: pushkin_uid },
  { name: 'Барышня-крестьянка',  genre_id: story_id,   author_uid: pushkin_uid },
  { name: 'Сказка о рыбаке и рыбке',  genre_id: fairy_tale_id,   author_uid: pushkin_uid },
  { name: 'Сказка о золотом петушке',  genre_id: fairy_tale_id,   author_uid: pushkin_uid },
]

books.each do |book|
  Book.create(
    book_uid: SecureRandom.uuid,
    name: book[:name],
    genre_id: book[:genre_id],
    author_uid: book[:author_uid]
  )
end
