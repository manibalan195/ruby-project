books = []

def show_english_menu
  puts "\n\n*** LIBRARY MANAGEMENT SYSTEM ***"
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. Search book"
  puts "4. Delete book"
  puts "5. Update book"
  puts "6. Exit"
  puts "7. List all books"
  puts "8. Browse book by gener"
end

def add_book(books,hash)
  books.push(hash)
end

def display_books(books,limit) # For both option 2(display first 3) & 7(display all books)  
  if !books.empty? 
    books.first(limit).each.with_index(1) { |book,index| 
      puts "#{index}. #{book[:title]} - #{book[:author]} - #{book[:gener]} (#{book[:year]})"
    }
  else
    puts "Books not available."
  end
end

def delete_book(books,title)
  if books.reject! {|book| book[:title] == title} # ! Modifies in orignal array. It return new array or nil.
    puts "Book successfully deleted."
  else
    puts "Book not found." 
  end
end

def search_by_gener(books,gener)
  matched_books = books.select {|book| book[:gener].downcase == gener.downcase}
  return matched_books
end

loop do
  show_english_menu
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
    
    print "Gener : "
    gener = gets.chomp

    print "Year : "
    year = gets.chomp.to_i

    add_book(books, {title:title, author:author, gener:gener, year:year})
    puts "Book added Successfully..."

  when 2
    puts "Listing First 3 books..."
    display_books(books,3)

  when 3
    puts "Searching for a book..."

  when 4
    puts "Deleting a book..."
    print "Enter Book title to delete : "
    title = gets.chomp
    delete_book(books,title)

  when 5
    puts "Updating a book..."

  when 6
    puts "Exiting..."
    break
  when 7
    puts "Listing all books..."
    display_books(books, books.length)
  
  when 8
    puts "Searching by gener..."
    print "Enter Gener to search : "
    gener = gets.chomp
    
    matched_books = search_by_gener(books, gener)
    display_books(matched_books,matched_books.length)

  else
    puts "Invalid option. Please try again."
  end
end

