class TakenBooksWorker
  include Sneakers::Worker
  # This worker will connect to 'taken_books' queue
  # env is set to nil since by default the actuall queue name would be
  # "taken_books_development" or "taken_books_production"
  from_queue 'taken_books', env: nil

  def work(message)
    puts "MESSAGE"
    puts message
    taken_book = JSON.parse(message)
    puts taken_book['message']
    # data = ActiveSupport::JSON.decode(msg)
    # data['users'].each do |user|
    #   update_user(user.to_h)
    # end
    Rails.logger.info "New message from taken_books queue: #{taken_book}"
    Sneakers.logger.info "HJHJHJHJHJH"
    ack!
  rescue StandardError => e
    Rails.logger.info "Error: #{e.message}"
    reject!
  end

  private

  # def update_user(user_hash)
  #   user = User.find_by(id: user_hash['id'])
  #   user.assign_attributes user_hash.slice('first_name', 'last_name', 'email').compact
  #   user.save!
  # rescue StandardError => e
  #   create_log(false, user, message: e.message)
  # end

  # def create_log(success, payload, message = {})
  #   message = {
  #     success: success,
  #     payload: payload
  #   }.merge(message).to_json

  #   severity = success ? :info : :error
  #   Rails.logger.send(severity, message)
  # end
end
