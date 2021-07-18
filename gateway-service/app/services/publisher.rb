class Publisher
  def self.publish(queue_name, message = {})
    # По умолчанию exchange отправляет все сообщения в ту очередь,
    # которой соответствует ключ маршрутизации (direct exchange).

    RabbitConnection.instance.channel.with do |channel|
      exchange = channel.default_exchange
      exchange.publish(message.to_json, routing_key: queue_name)
    end
  end
end
