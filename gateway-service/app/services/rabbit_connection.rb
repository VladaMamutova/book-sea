require 'connection_pool'

require 'singleton'

class RabbitConnection
  include Singleton

  attr_reader :connection

  def initialize
    # Открываем соединение с контейнером, в котором запущен rabbitmq
    @connection = Bunny.new(
      host: 'rabbitmq',
      username: ENV['RABBITMQ_USERNAME'],
      password: ENV['RABBITMQ_PASSWORD'],
      port: 5672,
      vhost: '/',
      automatically_recover: true,
      connection_timeout: 2,
      continuation_timeout: 4000,
      logger: Rails.logger
    )
    @connection.start
  end

  def channel
    @channel ||= ConnectionPool.new do
      connection.create_channel
    end
  end
end