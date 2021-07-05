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
      taken_book
    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"
      Rails.logger.info "Request to Library Service to remove taken book '#{taken_book['taken_book_uid']}'"
      LibraryService.new.remove_taken_book(taken_book['taken_book_uid'])
      raise e
    end
  end

  def return_book_to_library(user_uid, book_uid, library_uid, status)
    Rails.logger.info "Request to Library Service to return book '#{book_uid}' from library '#{library_uid}' for user '#{user_uid}'"
    returned_book = LibraryService.new.return_book(user_uid, book_uid, library_uid, status)

    return_info = {
      taken_book_uid: returned_book['taken_book_uid'],
      in_time: returned_book['in_time'],
      good_condition: returned_book['good_condition']
    }
    begin
      Rails.logger.info "Request to Control Service to remove taken book '#{returned_book['taken_book_uid']}' for user '#{user_uid}'"
      ControlService.new.remove_taken_book(user_uid, returned_book['taken_book_uid'])
    rescue StandardError => e
      Rails.logger.info "Error: #{e.message}"
      Rails.logger.info "Request to Library Service to cancel return of taken book '#{returned_book['taken_book_uid']}'"
      LibraryService.new.cancel_return(returned_book['taken_book_uid'])
      raise e
    end

    begin      
      Rails.logger.info "Request to Rating Service to update score for user '#{user_uid}'"
      rating = RatingService.new.update_score(user_uid, returned_book['in_time'], returned_book['good_condition'])
      return_info['rating_status'] = rating['status']
      return_info['rating_score'] = rating['score']
      return_info['rating_operation'] = rating['operation']
      return_info['limit'] = rating['limit']

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

          begin
            Rails.logger.info "Request to Book Service to get book '#{taken_book_info['book_uid']}' for taken book '#{taken_book_uid}'"
            book = get_book_info(taken_book_info['book_uid'])
            taken_book['book_uid'] = book['book_uid']
            taken_book['book_name'] = book['name']
          rescue StandardError => e
            Rails.logger.info "Error: #{e.message}"
          end

          begin
            Rails.logger.info "Request to Library Service to get library '#{taken_book_info['library_uid']}' for taken book '#{taken_book_uid}'"
            library = LibraryService.new.get_library_info(taken_book_info['library_uid'])
            taken_book['library_uid'] = library['library_uid']
            taken_book['library_name'] = library['name']
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
