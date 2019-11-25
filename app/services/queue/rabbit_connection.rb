class RabbitConnection
  include Singleton

  def initialize
    @conn = Bunny.new
    @started = false
  end

  def channel
    @started = true unless @started
    @channel ||= @conn.create_channel
  end
end
