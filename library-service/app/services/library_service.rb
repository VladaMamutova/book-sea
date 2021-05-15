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

  def remove_library_book(library, book_uid)
    library_book = get_library_book(library, book_uid)
    available_count = library_book.nil? ? 0 : library_book.available_count
    if available_count.positive?
      available_count = library_book.available_count - 1
      library_book.update(available_count: available_count)
    end

    available_count
  end

  def take_library_book(library, book_uid)
    library_book = get_library_book(library, book_uid)

    available_count = library_book.nil? ? 0 : library_book.available_count
    raise StandardError, "Book '#{book_uid}' is not available" unless available_count.positive?

    library_book.update(available_count: library_book.available_count - 1)
  end

  def return_library_book(library, book_uid)
    library_book = get_library_book(library, book_uid)
    # use safe navigation (`&.`) to check for nil
    library_book&.update(available_count: library_book.available_count + 1)
  end

  private

  def get_library_book(library, book_uid)
    library.library_books.find_by(book_uid: book_uid) # nil if not found
    # == LibraryBook.find_by(library_id: library.id, book_uid: book_uid)
  end

  def create_library_book(library, book_uid)
    library.library_books.create(
      book_uid: book_uid,
      available_count: 0
    )
  end
end
