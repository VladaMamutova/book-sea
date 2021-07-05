class TakenBookService
  RENTAL_PERIOD = 10

  def take(user_uid, library_book)
    available_count = library_book.available_count
    raise Error::RecordNotAvailable, "Book '#{library_book.book_uid}' is not available" unless available_count.positive?

    ActiveRecord::Base.transaction do
      taken_book = TakenBook.create!(
        taken_book_uid: SecureRandom.uuid,
        user_uid: user_uid,
        book_uid: library_book.book_uid,
        library_uid: library_book.library.library_uid,
        status: 'new'
      )
      library_book.update(available_count: available_count - 1)

      taken_book
    end
  end

  def return(user_uid, library_book, status)
    ActiveRecord::Base.transaction do
      book_uid = library_book.book_uid
      library_uid = library_book.library.library_uid
      taken_book = TakenBook.where(user_uid: user_uid, book_uid: book_uid, library_uid: library_uid, status: 'new').last
      unless taken_book
        raise ActiveRecord::RecordNotFound,
              "Taken Book (book uid: '#{book_uid}', library uid: #{library_uid}, status: 'new') not found for user '#{user_uid}'"
      end

      raise ActiveRecord::RecordInvalid, taken_book unless StatusValidator.new.validate_status(taken_book, status)

      taken_book.update!(status: status)
      library_book.update(available_count: library_book.available_count + 1) if status != 'lost'

      return_info = {
        taken_book_uid: taken_book.taken_book_uid,
        take_date: taken_book.created_at,
        return_date: taken_book.updated_at,
        status: taken_book.status,
        in_time: (taken_book.updated_at.to_date - taken_book.created_at.to_date).to_i <= RENTAL_PERIOD,
        good_condition: taken_book.status == 'used'
      }
    end
  end

  def get_new_taken_books(book_uid, library_uid)
    TakenBook.where(book_uid: book_uid, library_uid: library_uid, status: 'new').count
  end
end
