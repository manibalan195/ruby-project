require_relative "book"

class DigitalBook < Book
  attr_accessor :url

  def initialize(title, author, year, url)
    super(title, author, year)
    @url = url
  end

  def display
    super
    puts "URL : #{@url}"
    puts "-" * 30
  end
end
