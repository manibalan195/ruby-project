require_relative "book"

class AudioBook < Book
  attr_reader :genre, :duration_minutes

  def initialize(title, author, year, genre, duration_minutes)
    super(title, author, year)

    raise InvalidInputError,
          "Duration must be a positive integer" if duration_minutes <= 0

    @genre = genre
    @duration_minutes = duration_minutes
  end

  def display
    puts "Title : #{title}"
    puts "Author : #{author}"
    puts "Year : #{year}"
    puts "Genre : #{@genre}"

    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60

    puts "Duration : #{hours}h #{minutes}m"
    puts "-" * 30
  end

  def to_s
    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60

    "#{title} | #{author} | (#{year}) | #{genre} | #{hours}h #{minutes}m"
  end
end
