class TakenBooksWorker
  include Sneakers::Worker
  # This worker will connect to 'taken_books' queue
  # env is set to nil since by default the actuall queue name would be
  # "taken_books_development" or "taken_books_production"
  from_queue 'taken_books', env: nil

  # work method receives message payload in raw format
  # in our case it is JSON encoded string
  # which we can pass to TakenBookService without changes
  def work(raw_taken_book)
    TakenBookService.push(raw_taken_book)
    ack! # we need to let queue know that message was received
  end
end
