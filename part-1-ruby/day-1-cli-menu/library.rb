def show_english_menu
    puts "*** LIBRARY MANAGEMENT SYSTEM ***"
    puts "1. Add a book"
    puts "2. List books"
    puts "3. Search book"
    puts "4. Delete book"
    puts "5. Update book"
    puts "6. Exit"
end

loop do
    show_english_menu
    print "Select an option: " # To get input in same line.
    option = gets.chomp.to_i
    puts "You selected option #{option}" unless option == 6

    case option
    when 1
        puts "Adding a book..."
    when 2
        puts "Listing books..."
    when 3
        puts "Searching for a book..."
    when 4
        puts "Deleting a book..."
    when 5
        puts "Updating a book..."
    when 6
        puts "Exiting..."
        break
    else
        puts "Invalid option. Please try again."
    end
end

