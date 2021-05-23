class LibraryBookService
  def add(library, book_uid, available_count)
    library_book = get_library_book(library, book_uid)
    if library_book.present?
      library_book.update!(available_count: library_book.available_count + available_count)
    else
      library_book = create_library_book(library, book_uid, available_count)
    end

    library_book
  end

  private

  def get_library_book(library, book_uid)
    library.library_books.find_by(book_uid: book_uid) # nil if not found
    # == LibraryBook.find_by(library_id: library.id, book_uid: book_uid)
  end

  def create_library_book(library, book_uid, available_count)
    library.library_books.create!(
      book_uid: book_uid,
      available_count: available_count
    )
  end
end
