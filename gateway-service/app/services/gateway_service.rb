class GatewayService
  GATEWAY_ID = 1
  GATEWAY_SECRET = Rails.application.secret_key_base
  private_constant :GATEWAY_ID
  private_constant :GATEWAY_SECRET

  def get_books(params)
    Rails.logger.info 'Request to Books Service to get books'
    BookService.new.get_books(params)

  # Отлавливаем ошибки микросервисной авторизации (RestClient::Unauthorized)
  # и истечение срока действия токена (RestClient::Forbidden).
  rescue RestClient::Unauthorized, RestClient::Forbidden
    # запрашиваем новый токен
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    # повторяем запрос
    Rails.logger.info 'Request to Books Service to get books again'
    BookService.new.get_books(params)
  end

  def get_book_info(book_uid)
    Rails.logger.info "Request to Books Service to get book '#{book_uid}'"
    BookService.new.get_book_info(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get book '#{book_uid}' again"
    BookService.new.get_book_info(book_uid)
  end

  def get_author_info(author_uid)
    Rails.logger.info "Request to Books Service to get author '#{author_uid}'"
    BookService.new.get_author_info(author_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get author '#{author_uid}' again"
    BookService.new.get_author_info(author_uid)
  end

  def get_author_with_books(author_uid)
    Rails.logger.info "Request to Books Service to get author '#{author_uid}' with books"
    BookService.new.get_author_with_books(author_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get author '#{author_uid}' with books again"
    BookService.new.get_author_with_books(author_uid)
  end

  def add_book(book_params)
    Rails.logger.info "Request to Books Service to add book (#{params_to_string(book_params)})"
    BookService.new.add_book(book_params)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to add book (#{params_to_string(book_params)}) again"
    BookService.new.add_book(book_params)
  end

  def remove_book(book_uid)
    Rails.logger.info "Request to Books Service to remove book '#{book_uid}'"
    BookService.new.remove_book(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to remove book '#{book_uid}'"
    BookService.new.remove_book(book_uid)
  end

  def get_authors
    Rails.logger.info 'Request to Books Service to get authors'
    BookService.new.get_authors

  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info 'Request to Books Service to get authors again'
    BookService.new.get_authors
  end

  def get_genres
    Rails.logger.info 'Request to Books Service to get genres'
    BookService.new.get_genres

  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info 'Request to Books Service to get genres again'
    BookService.new.get_genres
  end

  def add_book_to_library(book_uid, library_uid, number)
    raise Error::RecordInvalid.new('Validation failed', ['number must be greater than 0']) if number <= 0

    begin
      Rails.logger.info "Request to Books Service to add book '#{book_uid}' (number: #{number}) to library #{library_uid}"
      BookService.new.add_book_to_library(book_uid, library_uid)
    rescue RestClient::Unauthorized, RestClient::Forbidden
      Rails.logger.info 'Request to Book Service for a token'
      BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

      Rails.logger.info "Request to Books Service to add book '#{book_uid}' (number: #{number}) to library '#{library_uid}'"
      BookService.new.add_book_to_library(book_uid, library_uid)
    end

    LibraryService.new.add_book_to_library(book_uid, library_uid, number)
  end

  def remove_book_from_library(book_uid, library_uid)
    LibraryService.new.remove_book_from_library(book_uid, library_uid)

    begin
      Rails.logger.info "Request to Books Service to remove book '#{book_uid}' from library '#{library_uid}'"
      BookService.new.remove_book_from_library(book_uid, library_uid)
    rescue RestClient::Unauthorized, RestClient::Forbidden
      Rails.logger.info 'Request to Book Service for a token'
      BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

      Rails.logger.info "Request to Books Service to remove book '#{book_uid}' from library '#{library_uid}'"
      BookService.new.remove_book_from_library(book_uid, library_uid)
    end
  end

  def get_library_books(library_uid)
    library_books = LibraryService.new.get_library_books(library_uid)
    books = []
    library_books.each do |library_book|
      book_uid = library_book['book_uid']
      available_count = library_book['available_count']

      begin
        book = get_book_info(book_uid)
        book['available_count'] = available_count
        books << book
      rescue StandardError => e
        Rails.logger.info "Error: #{e.message}"
      end
    end

    books
  end

  def find_book_in_libraries(book_uid)
    libraries = []

    begin
      library_uids = get_book_libraries(book_uid)

      library_uids.each do |library_uid|
        begin
          libraries << LibraryService.new.get_library_book_info(library_uid, book_uid)
        rescue StandardError => e
          Rails.logger.info "Error: #{e.message}"
        end
      end
    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"
    end

    libraries
  end

  def take_book(user_uid, book_uid, library_uid)
    Rails.logger.info "Request to Library Service to take book '#{book_uid}' from library '#{library_uid}' for user '#{user_uid}'"
    taken_book = LibraryService.new.take_book(user_uid, book_uid, library_uid)

    begin
      Rails.logger.info "Request to Control Service to add taken book '#{taken_book['taken_book_uid']}' for user '#{user_uid}'"
      ControlService.new.add_taken_book(user_uid, taken_book['taken_book_uid'])

      Rails.logger.info "Publish taken book '#{taken_book['taken_book_uid']}' info to taken_books queue"
      begin
        Publisher.publish('taken_books', taken_book)
      rescue StandardError => e
        Rails.logger.error "Error: #{e.message}"
      end

      taken_book
    rescue StandardError => e
      Rails.logger.error "Error: #{e.message}"
      Rails.logger.error "Request to Library Service to remove taken book '#{taken_book['taken_book_uid']}'"
      LibraryService.new.remove_taken_book(taken_book['taken_book_uid'])
      raise e
    end
  end

  def return_book_to_library(user_uid, book_uid, library_uid, status)
    Rails.logger.info "Request to Library Service to return book '#{book_uid}' from library '#{library_uid}' for user '#{user_uid}'"
    returned_book = LibraryService.new.return_book(user_uid, book_uid, library_uid, status)

    return_info = {
      taken_book_uid: returned_book['taken_book_uid'],
      return_date: returned_book['return_date'],
      in_time: returned_book['in_time'],
      status: returned_book['status']
    }
    begin
      Rails.logger.info "Request to Control Service to remove taken book '#{returned_book['taken_book_uid']}' for user '#{user_uid}'"
      ControlService.new.remove_taken_book(user_uid, returned_book['taken_book_uid'])

      Rails.logger.info "Publish returned book '#{returned_book['taken_book_uid']}' info to returned_books queue"
      begin
        Publisher.publish('returned_books', return_info)
      rescue StandardError => e
        Rails.logger.error "Error: #{e.message}"
      end

    rescue StandardError => e
      Rails.logger.error "Error: #{e.message}"
      Rails.logger.error "Request to Library Service to cancel return of taken book '#{returned_book['taken_book_uid']}'"
      LibraryService.new.cancel_return(returned_book['taken_book_uid'])
      raise e
    end

    begin
      Rails.logger.info "Request to Rating Service to update score for user '#{user_uid}'"
      rating = RatingService.new.update_score(user_uid, returned_book['in_time'], returned_book['status'])
      return_info['rating_status'] = rating['status']
      return_info['rating_score'] = rating['score']
      return_info['rating_operation'] = rating['operation']
      return_info['book_limit'] = rating['limit']

      if rating['operation'] != 'none'
        Rails.logger.info "Request to Control Service to update the limit of taken books for user '#{user_uid}'"
        ControlService.new.update_limit(user_uid, rating['limit'])
      end

    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"
    end

    return_info
  end

  def show_taken_books(user_uid)
    taken_books = []

    begin
      Rails.logger.info "Request to Control Service to get taken books by user '#{user_uid}'"
      taken_book_uids = ControlService.new.show_taken_books(user_uid)

      taken_book_uids.each do |taken_book_uid|
        Rails.logger.info "Processing user '#{user_uid}' taken book '#{taken_book_uid}'"
        taken_book = { taken_book_uid: taken_book_uid }
        begin
          Rails.logger.info "Request to Library Service to get taken book '#{taken_book_uid}'"
          taken_book_info = LibraryService.new.get_taken_book_info(taken_book_uid)
          taken_book['take_date'] = taken_book_info['take_date']

          taken_book['book_uid'] = taken_book_info['book_uid']
          begin
            Rails.logger.info "Request to Book Service to get book '#{taken_book_info['book_uid']}' for taken book '#{taken_book_uid}'"
            book = get_book_info(taken_book_info['book_uid'])
            taken_book['name'] = book['name']
            taken_book['author'] = book['author']
          rescue StandardError => e
            Rails.logger.info "Error: #{e.message}"
          end

          taken_book['library_uid'] = taken_book_info['library_uid']
          begin
            Rails.logger.info "Request to Library Service to get library '#{taken_book_info['library_uid']}' for taken book '#{taken_book_uid}'"
            library = LibraryService.new.get_library_info(taken_book_info['library_uid'])
            taken_book['library'] = library['name']
          rescue StandardError => e
            Rails.logger.info "Error: #{e.message}"
          end

          taken_books << taken_book
        rescue StandardError => e
          Rails.logger.info "Error: #{e.message}"
        end
      end
    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"
    end

    taken_books
  end

  def show_user_rating(user_uid)
    Rails.logger.info "Request to Rating Service to get user '#{user_uid}' rating"
    RatingService.new.show_user_rating(user_uid)
  end

  def show_books_genre_report
    Rails.logger.info 'Request to Report Service to get books genre report'
    ReportService.new.books_genre_report
  end

  def show_books_return_report(token)
    Rails.logger.info 'Request to Report Service to get books return report'
    user_books = ReportService.new.books_return_report

    user_books.each do |user_book|
      begin
        user = SessionService.new.get_user_info(token, user_book['user_uid'])
        user_book['login'] = user['login']
      rescue StandardError => e
        Rails.logger.info "Error: #{e.message}"
      end
    end

    user_books
  end

  def sign_up(token, login, password)
    Rails.logger.info "Request to Session Service to register user with login '#{login}'"
    response = SessionService.new.register(token, login, password)

    user_uid = response['user_uid']
    begin
      Rails.logger.info "Request to Rating Service to create rating for user '#{user_uid}'"
      rating = RatingService.new.create_rating(user_uid)

      begin
        Rails.logger.info "Request to Control Service to start monitoring for user '#{user_uid}' (book limit: #{rating['limit']})"
        ControlService.new.start_monitoring(user_uid, rating['limit'])
      rescue StandardError => e
        Rails.logger.info "Error: #{e.message}"

        Rails.logger.info "Request to Rating Service to remove rating for user '#{user_uid}'"
        RatingService.new.delete_rating(user_uid)

        raise e
      end
    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"

      Rails.logger.info "Request to Session Service to delete user '#{user_uid}' account (login: '#{login}')"
      SessionService.new.delete_account(token, user_uid)

      raise Error::RegistrationFailed, e.message
    end
  end

  def show_user_ratings(token)
    Rails.logger.info 'Request to Session Service to get users'
    users = SessionService.new.get_users_info(token)

    user_ratings = []
    users.each do |user|
      begin
        rating = show_user_rating(user['user_uid'])
        user_rating = {
          user_uid: user['user_uid'],
          login: user['login'],
          status: rating['status'],
          score: rating['score'],
          limit: rating['limit']
        }
        user_ratings << user_rating
      rescue StandardError => e
        Rails.logger.info "Error: #{e.message}"
      end
    end

    user_ratings
  end

  private

  def get_book_libraries(book_uid)
    Rails.logger.info "Request to Books Service to get libraries for book '#{book_uid}'"
    BookService.new.get_book_libraries(book_uid)
  rescue RestClient::Unauthorized, RestClient::Forbidden
    Rails.logger.info 'Request to Book Service for a token'
    BookService.new.request_token(GATEWAY_ID, GATEWAY_SECRET)

    Rails.logger.info "Request to Books Service to get libraries for book '#{book_uid}'"
    BookService.new.get_book_libraries(book_uid)
  end

  def params_to_string(params)
    hash = params.to_h
    hash.map { |key, value| "#{key.gsub('_', ' ')}: '#{value}'" }.join(', ')
  end

  def extract_message(response)
    JSON.parse(response.body)['message']
  end
end
