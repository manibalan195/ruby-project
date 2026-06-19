require_relative "../modules/searchable"
require_relative "../modules/exportable"
require_relative "book"
require_relative "digital_book"
require_relative "audio_book"

class Library
  include Searchable
  include Exportable
  attr_accessor :books

  def initialize
    @books = []
  end

  def add(title, author, year)
    @books << Book.new(title, author, year)
  end

  def all_books 
    @books
  end

  def add_digital_book(title, author, year, url)
    @books << DigitalBook.new(title, author, year, url)
    puts "Digital Book added!"
  end

  def add_audio_book(title, author, year, genre, duration_minutes)
    @books << AudioBook.new(
      title,
      author,
      year,
      genre,
      duration_minutes
    )

    puts "Audiobook added!"
  end

  
  def list(limit: nil)
    collection = limit ? @books.first(limit) : @books

    if collection.empty?
      puts "No books found."
    else
      collection.each do |book|
        book.display
      end
    end
  end

  def delete(title)
    before = @books.length

    @books.reject! do |book|
      book.title.downcase == title.downcase
    end

    @books.length < before ? puts("Deleted.") : puts("Not found.")
  end

  def size
    @books.length
  end

  def stats
    return {
      total: 0,
      by_genre: {},
      average_year: 0
    } if @books.empty?

    genre_count = {}

    @books.each do |book|
      genre_count[book.genre] ||= 0
      genre_count[book.genre] += 1
    end

    total_years = 0

    @books.each do |book|
      total_years += book.year
    end

    {
      total: @books.length,
      by_genre: genre_count,
      average_year: (total_years.to_f / @books.length).round(2)
    }
  end

  private

  def find_index(title)
    @books.index do |book|
      book.title.downcase == title.downcase
    end
  end
end
