require "csv"
require "fileutils"

require_relative "models/library"

require_relative "exceptions/invalid_input_error"
require_relative "exceptions/book_not_found_error"

BACKUP_FILE = "data/books_backup.csv"
SAVE_FILE = "data/books.csv"
FileUtils.mkdir_p("data")

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
      library.add(row["title"],row["author"],row["year"].to_i)
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

def prompt_required(message)
  print message
  value = gets.to_s.chomp
  raise InvalidInputError, "Input cannot be blank" if value.strip.empty?
  value
end

def prompt_year(message)
  print message
  year_input = gets.chomp
  raise InvalidInputError,
        "Year must be a number" unless year_input.match?(/^\d+$/)
  year_input.to_i
end

def prompt_duration(message)
  print message
  duration_input = gets.chomp
  raise InvalidInputError,
        "Duration must be a positive integer" unless duration_input.match?(/^\d+$/)
  duration_input.to_i
end

library = Library.new

load_library(library)
at_exit do
  create_backup
  save_library(library)
end

begin
  loop do
    puts "\n=== LIBRARY MANAGEMENT SYSTEM ===\n\n"
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
    puts "11. Library Statistics"
    puts "12. Export Book"
    puts "13. Exit\n\n"

    print "Enter your choice: "
    choice = gets.chomp.to_i

    case choice

    when 1
      title = prompt_required("Enter title: ")
      author = prompt_required("Enter author: ")
      year = prompt_year("Enter year: ")
      library.add(title, author, year)
      puts "Book added!"

    when 2
      library.list(limit: 3)

    when 3
      library.list

    when 4
      query = prompt_required("Enter title to search: ")
      book = library.find_by_title(query)
      raise BookNotFoundError.new(query) unless book
      puts "\nBook Found:"
      book.display

    when 5
      query = prompt_required("Enter author name to search: ")
      books = library.find_by_author(query)
      raise BookNotFoundError.new(query) if books.empty?
      
      puts "\nBooks Found:"
      books.each do |book|
        book.display
      end

    when 6
      title = prompt_required("Enter title to delete: ")
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
      title = prompt_required("Enter title: ")
      author = prompt_required("Enter author: ")
      year = prompt_year("Enter year: ")
      url = prompt_required("Enter URL: ")
      library.add_digital_book(title, author, year, url)
    
    when 10
      title = prompt_required("Enter title: ")
      author = prompt_required("Enter author: ")
      year = prompt_year("Enter year: ")
      genre = prompt_required("Enter genre: ")
      duration = prompt_duration("Enter duration in minutes: ")
      library.add_audio_book(title,author,year,genre,duration)

    when 11
      result = library.stats
      puts "\n--- Library Statistics ---"
      puts "Total Books: #{result[:total]}"
      puts "Books By Genre: #{result[:by_genre]}"
      puts "Average Year: #{result[:average_year]}"

    when 12
      query = prompt_required("Enter Book title: ")
      puts "\nCSV Export:"
      puts library.to_csv_row(query)

    when 13
      puts "Exiting..."
      break

    else
      puts "Invalid choice!"
    end

    rescue BookNotFoundError => e
      puts "Error: #{e.message}"

    rescue InvalidInputError => e
      puts "Invalid Input: #{e.message}"
  end

rescue Interrupt
  puts "\nGoodbye!"

ensure
  puts "Session ended."
end
