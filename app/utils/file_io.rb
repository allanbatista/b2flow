class FileIo < StringIO
  attr_reader :original_filename

  def initialize(*args)
    super(*args[1..-1])
    @original_filename = args[0]
  end
end