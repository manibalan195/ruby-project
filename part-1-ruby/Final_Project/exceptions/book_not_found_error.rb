class BookNotFoundError < StandardError
  def initialize(title)
    super("Book not found: #{title}")
  end
end