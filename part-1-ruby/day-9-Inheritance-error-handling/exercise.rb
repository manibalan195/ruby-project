require_relative "modules.rb"

class InvalidInputError < StandardError
end

class Book
  attr_reader :title, :author, :year, :genre

  def initialize(title, author, year, genre)
    @title = title
    @author = author
    @year = year
    @genre = genre
  end

  def display
    puts "Title : #{@title}"
    puts "Author : #{@author}"
    puts "Year : #{@year}"
    puts "Genre : #{@genre}"
  end

  def to_s
    "#{title} | #{author} | (#{year}) | #{genre}"
  end
end

# ===== AudioBook Subclass =====

class AudioBook < Book
  attr_reader :duration_minutes

  def initialize(title, author, year, genre, duration_minutes)
    super(title, author, year, genre)
    @duration_minutes = duration_minutes
  end

  def display
    super

    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60

    puts "Duration : #{hours}h #{minutes}m"
  end

  def to_s
    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60

    "#{title} | #{author} | (#{year}) | #{genre} | #{hours}h #{minutes}m"
  end
end

class Library
  include Exportable

  def initialize
    @books = []
  end

  def add(title, author, year, genre)
    @books.push(Book.new(title, author, year, genre))
    puts "Book added!"
  end

  # ===== Add Audiobook =====

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
      collection.each_with_index do |book, i|
        puts "#{i + 1}. #{book}"
      end
    end
  end

  def find(query)
    @books.find do |book|
      book.title.downcase.include?(query.downcase)
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

library = Library.new

begin
  loop do
    puts "\n*** LIBRARY MANAGEMENT SYSTEM ***"
    puts "1. Add a Book"
    puts "2. List First 3 Books"
    puts "3. List All Books"
    puts "4. Search Book"
    puts "5. Delete Book"
    puts "6. Total Books"
    puts "7. Exit"
    puts "9. Library Statistics"
    puts "10. Export book to clipboard format"
    puts "11. Add Audiobook"

    print "Enter your choice: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Enter title: "
      title = gets.chomp

      print "Enter author: "
      author = gets.chomp

      print "Enter year: "
      year = gets.chomp.to_i

      print "Genre: "
      genre = gets.chomp

      library.add(title, author, year, genre)

    when 2
      library.list(limit: 3)

    when 3
      library.list

    when 4
      print "Enter title to search: "
      query = gets.chomp

      book = library.find(query)

      if book
        puts "Found: #{book}"
      else
        puts "Book not found."
      end

    when 5
      print "Enter title to delete: "
      title = gets.chomp

      library.delete(title)

    when 6
      puts "Total books: #{library.size}"

    when 7
      puts "Exiting..."
      break

    when 9
      result = library.stats

      puts "\n--- Library Statistics ---"
      puts "Total Books: #{result[:total]}"
      puts "Books By Genre: #{result[:by_genre]}"
      puts "Average Year: #{result[:average_year]}"

    when 10
      puts "--- Export book to clipboard format ---"
      print "Enter book title : "
      query = gets.chomp.strip

      result = library.to_csv_row(query)
      puts result

    when 11
      print "Enter title: "
      title = gets.chomp

      print "Enter author: "
      author = gets.chomp

      print "Enter year: "
      year = gets.chomp.to_i

      print "Genre: "
      genre = gets.chomp

      print "Duration in minutes: "
      duration_input = gets.chomp

      raise InvalidInputError,
            "Duration must be a positive integer" unless duration_input.match?(/^\d+$/)

      duration = duration_input.to_i

      raise InvalidInputError,
            "Duration must be greater than zero" if duration <= 0

      library.add_audiobook(
        title,
        author,
        year,
        genre,
        duration
      )

    else
      puts "Invalid choice!"
    end
  end

rescue InvalidInputError => e
  puts "Error: #{e.message}"

ensure
  puts "Session ended."
end