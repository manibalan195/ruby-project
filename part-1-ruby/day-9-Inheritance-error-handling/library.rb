require_relative "modules.rb"

# ===== CUSTOM EXCEPTIONS =====

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
    @year <=> other.year
  end
end

# ===== DIGITAL BOOK SUBCLASS =====

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

  # ===== ADD DIGITAL BOOK =====

  def add_digital_book(title, author, year, url)
    @books << DigitalBook.new(title, author, year, url)
    puts "Digital Book added!"
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

library = Library.new

# ===== BEGIN / RESCUE / ENSURE =====

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
    puts "10. Exit"

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