class TakenBookService
  def self.push(raw_taken_book, logger)
    @taken_book = TakenBook.new(
      taken_book_uid: raw_taken_book['taken_book_uid'],
      user_uid: raw_taken_book['user_uid'],
      take_date: DateTime.parse(raw_taken_book['take_date']),
      status: raw_taken_book['status'],
      book_uid: raw_taken_book['book_uid']
    )

    begin
      book = BookService.new.get_book_info(raw_taken_book['book_uid'], logger)

      @taken_book.book = book['name']
      @taken_book.author = book['author']['first_name']
      @taken_book.author += " #{book['author']['middle_name']}" if book['author']['middle_name']
      @taken_book.author += " #{book['author']['last_name']}"
      @taken_book.genre = book['genre']
    rescue StandardError => e
      logger.error "Taken Books: Failed to get book '#{raw_taken_book['book_uid']}' info: #{e.message}"
    end

    if @taken_book.save
      logger.info "Taken Books: Add new taken book '#{@taken_book.taken_book_uid}': #{@taken_book.attributes}"
    else
      logger.error "Taken Books: Failed to add new taken book '#{@taken_book.taken_book_uid}': #{@taken_book.errors.messages}"
    end
  end
end
