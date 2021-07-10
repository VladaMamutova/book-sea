# # dashboard/app/workers/posts_worker.rb
# class BooksReturnWorker
#   include Sneakers::Worker
#   # This worker will connect to "dashboard.posts" queue
#   # env is set to nil since by default the actuall queue name would be
#   # "dashboard.posts_development"
#   from_queue "dashboard.posts", env: nil

#   # work method receives message payload in raw format
#   # in our case it is JSON encoded string
#   # which we can pass to RecentPosts service without
#   # changes
#   def work(raw_post)
#     RecentPosts.push(raw_post)
#     ack! # we need to let queue know that message was received
#   end
# end

class ReturnedBooksWorker
  # include Sneakers::Worker
  # # This worker will connect to 'taken_books' queue
  # # env is set to nil since by default the actuall queue name would be
  # # "taken_books_development" or "taken_books_production"
  # from_queue 'returned_books', env: nil

  # # work method receives message payload in raw format
  # # in our case it is JSON encoded string
  # # which we can pass to TakenBookService without changes
  # def work(raw_taken_book)
  #   puts "HELLO"
  #   #TakenBookService.push(raw_taken_book)
  #   ack! # we need to let queue know that message was received
  # end
end