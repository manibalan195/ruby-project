books = []

def show_english_menu
  return "\n\n*** LIBRARY MANAGEMENT SYSTEM ***
  1. Add a book
  2. List first 3 books
  3. Search book
  4. Delete book
  5. Update book
  6. Exit
  7. List all books
  8. Browse book by gener
  9. Book summary\n " 
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
    new_title = gets.chomp

    if books.any? { |b| b[:title].downcase == new_title.downcase && b != book }
      return "A book with that title already exists."
    end

    print "Enter book's new author : "
    book[:author] = gets.chomp
    print "Enter book's new year : "
    book[:year] = gets.chomp.to_i
    book[:title] = new_title

    return "Book details updated successfully."
  else
    return "Book not found"
  end
end

def search_by_gener(books,gener)
  matched_books = books.select {|book| book[:gener].downcase == gener.downcase}
  return matched_books
end

def book_summary(books)
  unless books.empty? 
    puts "Total no of books  #{books.length} "
    puts "Most recent added book : #{books.last}"
    puts "Oldest Book : #{books.min_by {|b| b[:year]}}"
  else
    puts "Library is empty."
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
    puts "Searching by gener..."
    print "Enter Gener to search : "
    gener = gets.chomp
    
    matched_books = search_by_gener(books, gener)
    display_books(matched_books,matched_books.length)

  when 9 
    puts "Library summary..."
    book_summary(books)
  else
    puts "Invalid option. Please try again."
  end
end

