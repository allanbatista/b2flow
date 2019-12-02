module Broaker
  class RabbitConnection
    include ::Singleton

    def initialize
      @conn = Bunny.new(AppConfig.B2FLOW__RABBIT__URI)
      @started = false
    end

    def channel
      unless @started
        @conn.start
        @started = true
      end
      @channel ||= @conn.create_channel
    end
  end
end