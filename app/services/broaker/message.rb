module Broaker
  class Message
    attr_reader :consumer, :payload

    def initialize(consumer, payload)
      @consumer = consumer
      @payload = payload
    end

    def to_s
      payload
    end
  end
end