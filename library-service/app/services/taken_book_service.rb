class TakenBookService
  def take(user_uid, library_book)
    available_count = library_book.available_count
    raise Error::RecordNotAvailable, "Book '#{library_book.book_uid}' is not available" unless available_count.positive?

    ActiveRecord::Base.transaction do
      taken_book = TakenBook.create!(
        taken_book_uid: SecureRandom.uuid,
        user_uid: user_uid,
        book_uid: library_book.book_uid,
        status: 'new'
      )
      library_book.update(available_count: available_count - 1)

      taken_book
    end
  end

  def return(user_uid, library_book, taken_book_params)
    ActiveRecord::Base.transaction do
      book_uid = library_book.book_uid
      taken_book = TakenBook.find_by(user_uid: user_uid, book_uid: book_uid, status: 'new')
      raise ActiveRecord::RecordNotFound, "Taken Book '#{book_uid}' not found for user '#{user_uid}'" unless taken_book

      status = taken_book_params[:status]
      raise ActiveRecord::RecordInvalid, taken_book unless StatusValidator.new.validate_status(taken_book, status)

      taken_book.update!(status: status)
      library_book.update(available_count: library_book.available_count + 1) if status != 'lost'

      taken_book
    end
  end
end
