require_relative "modules.rb"

class Book
  attr_reader :title, :author, :year ,:genre

  
  def initialize(title, author, year, genre)
    @title = title
    @author = author
    @year = year
    @genre = genre
  end

  def to_s
    "#{title} | #{author} | (#{year}) | #{genre}"
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
    puts "---\nExport book to clipboard format---"
    print "Enter book title : "
    query = gets.chomp.strip

    result = library.to_csv_row(query)
    puts result
  else
    puts "Invalid choice!"
  end

end