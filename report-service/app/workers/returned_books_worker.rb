class ReturnedBooksWorker
  include Sneakers::Worker
  # This worker will connect to 'returned_books' queue
  # env is set to nil since by default the actuall queue name would be
  # "returned_books_development" or "returned_books_production"
  from_queue 'returned_books', env: nil

  def work(message)
    raw_returned_book = JSON.parse(message)
    logger.info "New message from returned_books queue: #{raw_returned_book}"
    ReturnedBookService.push(raw_returned_book, logger)
    ack!
  rescue StandardError => e
    logger.error "Error: #{e.message}"
    reject!
  end
end
