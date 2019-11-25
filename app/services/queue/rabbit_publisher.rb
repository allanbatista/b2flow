class RabbitPublisher
  attr_reader :queue_name, :queue

  def initialize(queue_name)
    @queue_name = queue_name
    @queue = RabbitConnection.instance.channel.queue(queue_name)
  end

  def enqueue(message)
    queue.publish(message)
  end
end