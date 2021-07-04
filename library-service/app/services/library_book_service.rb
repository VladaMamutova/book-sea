class LibraryBookService
  def add(library, book_uid, number)
    library_book = get_library_book(library, book_uid)
    if library_book.present?
      library_book.update!(available_count: library_book.available_count + number)
    else
      library_book = create_library_book(library, book_uid, number)
    end

    library_book
  end

  def add_one_if_exist(library, book_uid)
    library_book = get_library_book(library, book_uid)
    if library_book.present?
      library_book.update!(available_count: library_book.available_count + 1)
    end

    library_book
  end

  def remove(library_book)
    book_uid = library_book.book_uid
    library_uid = library_book.library.library_uid
    book_number = TakenBookService.new.get_new_taken_books(book_uid, library_uid)
    if book_number.positive?
      raise Error::RecordOperationConflict, "#{book_number} copies of the book '#{book_uid}' are taken from the library '#{library_uid}'"
    end

    library_book.destroy
  end

  private

  def get_library_book(library, book_uid)
    library.library_books.find_by(book_uid: book_uid) # nil if not found
    # == LibraryBook.find_by(library_id: library.id, book_uid: book_uid)
  end

  def create_library_book(library, book_uid, number)
    library.library_books.create!(
      book_uid: book_uid,
      available_count: number
    )
  end
end
