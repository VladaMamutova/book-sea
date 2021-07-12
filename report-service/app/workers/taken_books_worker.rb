class TakenBooksWorker
  include Sneakers::Worker
  # This worker will connect to 'taken_books' queue
  # env is set to nil since by default the actuall queue name would be
  # "taken_books_development" or "taken_books_production"
  from_queue 'taken_books', env: nil

  def work(message)
    taken_book = JSON.parse(message)
    logger.info "New message from taken_books queue: #{taken_book}"
    TakenBookService.push(taken_book)
    ack!
  rescue StandardError => e
    logger.error "Error: #{e.message}"
    reject!
  end
end
