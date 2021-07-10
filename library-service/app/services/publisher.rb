class Publisher
  def self.publish(queue_name, message = {})
    # По умолчанию exchange отправляет все сообщения в ту очередь,
    # которой соответствует ключ маршрутизации (direct exchange).
    exchange = channel.default_exchange
    exchange.publish(message.to_json, routing_key: queue_name)

    # exchange = channel.fanout("book_sea.#{exchange}")
    # exchange.publish(message.to_json)
  end

  def self.channel
    # Открываем новый канал, в рамках которого будем работать.
    # AMQP поддерживает одновременную работу со множеством каналов
    @channel ||= connection.create_channel
  end

  def self.connection
    # Открываем соединение с контейнером, в котором запущен rabbitmq
    @connection ||= Bunny.new('amqp://guest:guest@rabbitmq')
    @connection.start
  end
end
