books = []

def show_english_menu
  return "\n\n*** LIBRARY MANAGEMENT SYSTEM ***\n
  1. Add a book
  2. List first 3 books
  3. Search book
  4. Delete book
  5. Update book
  6. Exit
  7. List all books
  8. Developer Stats
  9. Books Between Years
  "
end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end
  true
end

def add_book(books,book_hash)
  if books.any? { |book| book[:title].downcase == book_hash[:title].downcase }
    return "Book already exists."
  else
    books.push(book_hash)
    return "Book added successfully..."
  end
end

def display_books(books,limit) # For both option 2(display first 3) & 7(display all books)  
  unless books.empty? 
    books.first(limit).each.with_index(1) { |book,index| 
      puts "#{index}. #{book[:title]} - #{book[:author]} (#{book[:year]})"
    }
  else
    puts "Books not available."
  end
end

def delete_book(books,title)
  if books.reject! {|book| book[:title].downcase == title.downcase } # ! Modifies in orignal array. It return new array or nil.
    return "Book successfully deleted."
  else
    return "Book not found." 
  end
end

def search_by_title(books, title) 
  book = books.find { |book| book[:title].downcase == title.downcase }
  if book 
    return "#{book[:title]} - #{book[:author]} (#{book[:year]})"
  else 
    return "Book not available."
  end
end

def update_book(books, title)
  book = books.find { |book| book[:title].downcase == title.downcase }
  if book 
    print "Enter book's new title : "
    new_title = gets.chomp.strip
    
    if !validate_input(new_title,"title")
      return "Enter valid new title."
    elsif books.any? { |b| b[:title].downcase == new_title.downcase && b != book }
      return "A book with that title already exists."
    end

    print "Rename : #{book[:title]} -> #{new_title} ? (y/n) "
    confirm = gets.chomp
    if confirm != 'y'
      return "Book title not updated."
    end

    book[:title] = new_title

    return "Book details updated successfully."
  else
    return "No book found with that title"
  end
end

def develop_stats(books)
  tot = books.length
  book_after_2000 = books.count { |b| b[:year] > 2000}
  uniq_author = books.map{|b| b[:author]}.uniq
  if tot > 0 
    puts "Total no of books : #{tot}"
    puts "Books after 2000  : #{book_after_2000}"
    puts "Authors : #{uniq_author}"
  else
    puts "Books array is empty."
  end
end

def books_between_years(books,start_year,end_year)
  return books.select do |b|
    b[:year] > start_year && b[:year] < end_year
  end
end

loop do
  puts show_english_menu
  print "Select an option: " # To get input in same line.
  option = gets.chomp.to_i
  puts "\n"
  puts "You selected option #{option}" unless option == 6

  case option
  when 1
    puts "Adding a book..."
    puts "Enter Details : "
    
    print "Title : "
    title = gets.chomp
    
    print "Author : "
    author = gets.chomp
    
    print "Year : "
    year = gets.chomp.to_i

    puts add_book(books, {title:title, author:author, year:year})
    
  when 2
    puts "Listing First 3 books..."
    display_books(books,3)

  when 3
    puts "Searching for a book..."
    print "Enter book title to search : "
    puts search_by_title(books, gets.chomp)

  when 4
    puts "Deleting a book..."
    print "Enter Book title to delete : "
    title = gets.chomp
    puts delete_book(books,title)

  when 5
    puts "Updating a book..."
    print "Enter book title to update : "
    puts update_book(books, gets.chomp)

  when 6
    puts "Exiting..."
    break
    
  when 7
    puts "Listing all books..."
    display_books(books, books.length)

  when 8
    puts "Developer Stats..."
    develop_stats(books)
  
  when 9 
    puts "Books between years..."
    
    print "Enter start year : "
    start_year = gets.chomp.to_i
    print "Enter end year : "
    end_year = gets.chomp.to_i
    if start_year > end_year
      puts "Start year should be less then end year. Try again!"
      next
    end

    selected_books = books_between_years(books,start_year,end_year)
    selected_books.sort_by! {|b| b[:year]}
    unless selected_books.empty?
      selected_books.each do |b|
        puts "#{b[:title]} - #{b[:author]} (#{b[:year]})"
      end
    else
      puts "Books not found in that range."
    end

  else
    puts "Invalid option. Please try again."
  end
end

