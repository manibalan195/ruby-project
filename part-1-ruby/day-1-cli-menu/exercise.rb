def show_spanish_menu 
    puts "1. Agregar un libro"
    puts "2. Listar libros"
    puts "3. Buscar libro"
    puts "4. Eliminar libro"
    puts "5. Actualizar libro"
    puts "6. Salir"
    puts "Press Enter to return to main menu..."
    gets
end

def show_english_menu
    puts "1. Add a book"
    puts "2. List books"
    puts "3. Search book"
    puts "4. Delete book"
    puts "5. Update book"
    puts "6. Exit"
end

loop do
    puts "*** LIBRARY MANAGEMENT SYSTEM ***"
    
    show_english_menu
    print "Select an option: "
    option = gets.chomp.to_i
    puts "You selected option #{option}" unless option == 6

    case option
    when 0
        show_spanish_menu
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

=begin

while condition
    # code to be executed
end

for variable in collection
    # code to be executed
end

for i in 0..10
    # code to be executed 
    # from 0 to 10 inclusive
end

for i in 0...10
    # code to be executed 
    # from 0 to 9 inclusive
end

5.times do
    # code to be executed 5 times
end

[1,2,3,4].each do |element|
    # code to be executed for each element 
end

=end

