class TakenBookService
  def self.push(taken_book)
    @taken_book = TakenBook.new(
      taken_book_uid: taken_book['taken_book_uid'],
      user_uid: taken_book['user_uid'],
      take_date: DateTime.parse(taken_book['take_date']),
      status: taken_book['status'],
      book_uid: taken_book['book_uid']
    )

    begin
      book = get_book_info(taken_book['book_uid'])

      @taken_book.book = book['name']
      @taken_book.author = book['author']['first_name']
      @taken_book.author += " #{book['author']['middle_name']}" if book['author']['middle_name']
      @taken_book.author += " #{book['author']['last_name']}"
      @taken_book.genre = book['genre']
    rescue StandardError => e
      Rails.logger.error "Taken Books: Tailed to add new taken book: #{e.message}"
    end

    if @taken_book.valid?
      @taken_book.save
      Rails.logger.info "Taken Books: Add new taken book: #{@taken_book.attributes}"
    else
      Rails.logger.error "Taken Books: Tailed to add new taken book: #{@taken_book.errors.messages}"
    end
  end

  private

  def get_book_info(book_uid)
    Rails.logger.info "Request to Books Service to get book '#{book_uid}'"
    BookService.new.get_book_info(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get book '#{book_uid}' again"
    BookService.new.get_book_info(book_uid)
  end
end
