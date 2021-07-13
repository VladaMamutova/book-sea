class ReportsController < ApplicationController
  def books_genre
    genre_popularity = TakenBook.where.not(genre: nil).group(:genre).order('count_all desc').count
    genre_popularity_response = genre_popularity.map { |genre, book_count| { genre: genre, book_count: book_count } }
    render json: genre_popularity_response
  end

  def books_return
    user_books = TakenBook.select("user_uid, 
      sum(case when in_time = 'true' AND status = 1 then 1 else 0 end) as in_time_count, 
      sum(case when status = 3 then 1 else 0 end) as lost, 
      sum(case when status = 2 then 1 else 0 end) as bad_condition,
      sum(case when status = 0 then 1 else 0 end) as new, 
      count(*) as count_all").group(:user_uid).order('in_time_count desc')

    user_books_response = user_books.map { |user_book|
      user_book_response = user_book.attributes
      user_book_response.delete('id')
      user_book_response
    }

    render json: user_books_response
  end
end
