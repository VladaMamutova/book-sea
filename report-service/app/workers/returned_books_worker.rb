class ReturnedBooksWorker
  include Sneakers::Worker
  # This worker will connect to 'returned_books' queue
  # env is set to nil since by default the actuall queue name would be
  # "returned_books_development" or "returned_books_production"
  from_queue 'returned_books', env: nil

  def work(raw_returned_book)
    puts "HELLO"
    data = JSON.parse(raw_returned_book)
    puts data['message']
    #TakenBookService.push(raw_taken_book)
    ack! # we need to let queue know that message was received
  rescue StandardError => e
    Rails.logger.info "Error: #{e.message}"
    reject!
  end
end
