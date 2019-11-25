class JobPublisher
  attr_reader :publisher

  def initialize(publisher)
    @publisher = publisher
  end

  def enqueue(job)
    publisher.enqueue(job.as_message.to_json)
  end
end
