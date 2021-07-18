class ReturnedBookService
  def self.push(raw_returned_book, logger)
    @taken_book = TakenBook.find_by(taken_book_uid: raw_returned_book['taken_book_uid'])

    logger.error "Taken book '#{raw_returned_book['taken_book_uid']}' not found" unless @taken_book
    return unless @taken_book

    @taken_book.return_date = raw_returned_book['return_date']
    @taken_book.status = raw_returned_book['status']
    @taken_book.in_time = raw_returned_book['in_time']

    if @taken_book.save
      logger.info "Returned Books: Taken book '#{@taken_book.taken_book_uid}' returned: #{@taken_book.attributes}"
    else
      logger.error "Returned Books: Failed to add return info of taken book '#{@taken_book.taken_book_uid}': #{@taken_book.errors.messages}"
    end
  end
end
