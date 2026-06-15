require_relative "modules.rb"

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

class Library

  include Searchable

  attr_accessor :books

  def initialize
    @books = []
  end

  def add(title, author, year)
    @books.push(Book.new(title, author, year))
    puts "Book added!"
  end

  def list(limit: nil)
    collection = limit ? @books.first(limit) : @books

    if collection.empty?
      puts "No books found."
    else
      collection.each_with_index do |book, i|
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

loop do
  puts "\n=== LIBRARY MANAGEMENT SYSTEM ==="
  puts "1. Add a Book"
  puts "2. List First 3 Books"
  puts "3. List All Books"
  puts "4. Search by Title"
  puts "5. Search by Author"
  puts "6. Delete Book"
  puts "7. Total Books"
  puts "8. Sort books"
  puts "9. Exit"

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

    library.add(title, author, year)

  when 2
    library.list(limit: 3)

  when 3
    library.list

  when 4
    print "Enter title to search: "
    query = gets.chomp

    book = library.find_by_title(query)

    if book
      puts "Found: #{book}"
    else
      puts "Book not found."
    end
  
  when 5
    print "Enter Author Name  to search: "
    query = gets.chomp

    books = library.find_by_author(query)

     if books.empty?
      puts "Book not found."
    else
      puts "\nBooks Found:"
      books.each do |book|
        puts book
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
      puts book
    end

  when 9
    puts "Exiting..."
    break

  else
    puts "Invalid choice!"
  end
end