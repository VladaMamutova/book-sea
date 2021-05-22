class GatewayService
  def add_book_to_library(book_uid, library_uid, available_count)
    if available_count <= 0
      raise Error::RecordInvalid.new('Validation failed', ['available_count must be greater than 0'])
    end

    BooksService.new.add_book_to_library(book_uid, library_uid)
    LibraryService.new.add_book_to_library(book_uid, library_uid, available_count)
  end

  def remove_book_from_library(book_uid, library_uid)
    LibraryService.new.remove_book_from_library(book_uid, library_uid)
    BooksService.new.remove_book_from_library(book_uid, library_uid)
  end
end
