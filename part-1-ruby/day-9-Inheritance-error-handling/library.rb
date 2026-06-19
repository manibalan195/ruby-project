require_relative "modules.rb"
require "CSV"
require "FileUtils"

BACKUP_FILE = "books_backup.csv"
SAVE_FILE = "books.csv"

class BookNotFoundError < StandardError
  def initialize(title)
    super("Book not found: #{title}")
  end
end

class InvalidInputError < StandardError
end

class Book
  include Displayable
  include Comparable

  attr_reader :title, :author, :year

  def initialize(title, author, year)
    @title = title
    @author = author
    @year = year
  end

  def <=>(other)
    return nil unless other.is_a?(Book)
    @year <=> other.year
  end
end


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

class Library
  include Searchable

  attr_accessor :books

  def initialize
    @books = []
  end

  def add(title, author, year)
    @books << Book.new(title, author, year)
    puts "Book added!"
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

  private

  def find_index(title)
    @books.index do |book|
      book.title.downcase == title.downcase
    end
  end
end


def save_library(library)
  CSV.open(SAVE_FILE,"w") do |csv|
    csv << ["title", "author", "year", "type", "genre","url", "duration_minutes"]
    library.all_books.each do |book|
      if(book.is_a?(DigitalBook))
        csv << [book.title, book.author, book.year, "digital", "",book.url, ""]
      elsif book.is_a?(AudioBook)
        csv << [book.title, book.author, book.year, "audio", book.genre,"", book.duration_minutes]
      else
        csv << [book.title, book.author, book.year, "physical", "", "", ""]
      end
    end
  end
  puts "Library Saved !"
end

def load_library(library)

  return unless File.exist?(SAVE_FILE)

  CSV.foreach(SAVE_FILE, headers: true) do |row|
    case row["type"]
    when "digital"
      library.add_digital_book(row["title"], row["author"], row["year"].to_i, row["url"] )
    when "audio"
      library.add_audio_book(
        row["title"],
        row["author"],
        row["year"].to_i,
        row["genre"],
        row["duration_minutes"].to_i
      )
    else
      library.add(
        row["title"],
        row["author"],
        row["year"].to_i
      )
    end
  end

  puts "Loaded #{library.size} books from file."
end

def create_backup
  if File.exist?(SAVE_FILE)
    FileUtils.cp( SAVE_FILE, BACKUP_FILE)
    puts "Backup created: books_backup.csv"
  end
end

library = Library.new

load_library(library)
at_exit do
  create_backup
  save_library(library)
end

begin
  loop do
    puts "\n=== LIBRARY MANAGEMENT SYSTEM ==="
    puts "1. Add a Book"
    puts "2. List First 3 Books"
    puts "3. List All Books"
    puts "4. Search by Title"
    puts "5. Search by Author"
    puts "6. Delete Book"
    puts "7. Total Books"
    puts "8. Sort Books"
    puts "9. Add Digital Book"
    puts "10. Add Audio Book"
    puts "11. Exit"

    print "Enter your choice: "
    choice = gets.chomp.to_i

    case choice

    when 1
      print "Enter title: "
      title = gets.chomp

      print "Enter author: "
      author = gets.chomp

      print "Enter year: "
      year_input = gets.chomp

      raise InvalidInputError, "Year must be a number" unless year_input.match?(/^\d+$/)

      year = year_input.to_i

      library.add(title, author, year)

    when 2
      library.list(limit: 3)

    when 3
      library.list

    when 4
      print "Enter title to search: "
      query = gets.chomp

      book = library.find_by_title(query)

      raise BookNotFoundError.new(query) unless book

      puts "\nBook Found:"
      book.display

    when 5
      print "Enter author name to search: "
      query = gets.chomp

      books = library.find_by_author(query)

      if books.empty?
        raise BookNotFoundError.new(query)
      else
        puts "\nBooks Found:"
        books.each do |book|
          book.display
        end
      end

    when 6
      print "Enter title to delete: "
      title = gets.chomp

      library.delete(title)

    when 7
      puts "Total books: #{library.size}"

    when 8
      sorted = library.books.sort

      puts "\nSorted Books:"
      sorted.each do |book|
        book.display
      end

    when 9
      print "Enter title: "
      title = gets.chomp

      print "Enter author: "
      author = gets.chomp

      print "Enter year: "
      year_input = gets.chomp

      raise InvalidInputError, "Year must be a number" unless year_input.match?(/^\d+$/)

      year = year_input.to_i

      print "Enter URL: "
      url = gets.chomp

      library.add_digital_book(title, author, year, url)
    
      when 10
        print "Enter title: "
        title = gets.chomp

        print "Enter author: "
        author = gets.chomp

        print "Enter year: "
        year_input = gets.chomp

        raise InvalidInputError,
              "Year must be a number" unless year_input.match?(/^\d+$/)

        year = year_input.to_i

        print "Enter genre: "
        genre = gets.chomp

        print "Enter duration in minutes: "
        duration_input = gets.chomp

        raise InvalidInputError,
              "Duration must be a positive integer" unless duration_input.match?(/^\d+$/)

        duration = duration_input.to_i

        library.add_audio_book(
          title,
          author,
          year,
          genre,
          duration
        )

    when 11
      puts "Exiting..."
      break

    else
      puts "Invalid choice!"
    end
  end

rescue BookNotFoundError => e
  puts "Error: #{e.message}"

rescue InvalidInputError => e
  puts "Invalid Input: #{e.message}"

rescue Interrupt
  puts "\nGoodbye!"

ensure
  puts "Session ended."
end

