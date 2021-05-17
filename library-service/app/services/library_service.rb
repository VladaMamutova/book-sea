class LibraryService
  def add_library_book(library, book_uid)
    library_book = get_library_book(library, book_uid)
    if library_book.present?
      library_book.update(available_count: library_book.available_count + 1)
    else
      library_book = create_library_book(library, book_uid)
    end

    library_book
  end

  def remove_library_book(library_book)
    available_count = library_book.available_count
    if available_count.positive?
      available_count = library_book.available_count - 1
      library_book.update(available_count: available_count)
    end

    available_count
  end

  def take_library_book(user_uid, library_book)
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

  def return_library_book(user_uid, library_book, status)
    ActiveRecord::Base.transaction do
      book_uid = library_book.book_uid
      taken_book = TakenBook.find_by(user_uid: user_uid, book_uid: book_uid)
      raise ActiveRecord::RecordNotFound, "Book '#{book_uid}' not found for user '#{user_uid}'" unless taken_book

      raise ActiveRecord::RecordInvalid.new(taken_book) unless StatusValidator.new.validate_status(taken_book, status)

      taken_book.update(status: status)
      library_book.update(available_count: library_book.available_count + 1)

      taken_book
    end
  end

  private

  def get_library_book(library, book_uid)
    library.library_books.find_by(book_uid: book_uid) # nil if not found
    # == LibraryBook.find_by(library_id: library.id, book_uid: book_uid)
  end

  def create_library_book(library, book_uid)
    library.library_books.create(
      book_uid: book_uid,
      available_count: 1
    )
  end
end
