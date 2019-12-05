module Broaker
  class RabbitConsumer
    attr_reader :queue_name, :queue, :channel, :deserialize

    def initialize(queue_name, deserialize=nil)
      @queue_name = queue_name
      @channel = RabbitConnection.instance.channel
      @queue = channel.queue(queue_name)
      @deserialize = deserialize
    end

    def pooling
      channel.prefetch(AppConfig.B2FLOW__BROAKER__BATCH_SIZE.to_i)
      queue.subscribe(:manual_ack => true, :blocking => false) do |delivery_info, _properties, payload|
        Thread.new do
          begin
            yield(Broaker::Message.new(self, parse(payload)))
          rescue => e
            Rails.logger.info("#{e.backtrace}\n#{payload}")
          ensure
            ack(delivery_info)
          end
        end
      end

      loop do
        sleep 1.0
      end
    end

    def ack(delivery_info)
      channel.acknowledge(delivery_info.delivery_tag, false)
    end

    def parse(payload)
      deserialize.present? ? deserialize.parse(payload) : payload
    end
  end
end
