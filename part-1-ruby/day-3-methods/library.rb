books = []

def show_english_menu
  return "\n\n*** LIBRARY MANAGEMENT SYSTEM ***\n
  1. Add a book\n
  2. List first 3 books\n
  3. Search book\n
  4. Delete book\n
  5. Update book\n
  6. Exit\n
  7. List all books\n"
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

  else
    puts "Invalid option. Please try again."
  end
end

