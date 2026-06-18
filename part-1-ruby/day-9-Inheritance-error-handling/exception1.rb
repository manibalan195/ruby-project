class InvalidAgeError < StandardError
end

def validate_age(age)
  raise InvalidAgeError,"Age must be a positive integer" if age <= 0
  puts "Valid age: #{age}"
end

begin

  print "Enter your age:"
  age = Integer(gets.chomp) # It raises ArgumentError if the input is not a valid integer
  validate_age(age)

  rescue InvalidAgeError => e  # It runs when InvalidAgeError is raised
    puts "Error : #{e.message}"
    puts "Class : #{e.class}"
    puts "Backtrace : #{e.backtrace}"

  rescue ArgumentError => e  # It runs when ArgumentError is raised
    puts "Error : #{e.message}"
    puts "Class : #{e.class}"

  else   # It runs when no exception is raised
    puts "Else Block : Age validation successful."

  ensure # It always runs, whether an exception was raised or not
    puts "Ensure Block : Validation Complete."
end
