BEGIN {   # It runs before any other code in the program, even before the main program starts
          # If multiple BEGIN blocks are defined, they will be executed in the order they were defined
  puts "Program Starting"
}

def divide(a,b)
  a / b

rescue
  "Cannot Divide"
end

puts divide(10,0)

result = Integer("abc") rescue 0 # It stops the exception from being raised and assigns 0 to result.

puts result

at_exit do # It runs when the program is about to exit, regardless of how it exits ,normal completion or exception
  puts "at_exit Executed"
end

END { # It runs after all other code in the program has executed, just before the program exits
      # If multiple END blocks are defined, they will be executed in the reverse order they were defined
  puts "END Block Executed"
}