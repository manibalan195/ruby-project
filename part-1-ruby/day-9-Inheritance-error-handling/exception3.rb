count = 0

begin
  count += 1 
  raise "An error has occurred" if count < 3
  puts "No error occurred"
rescue => e
  puts "Error: #{e.message}"
  retry 
ensure
  puts "Execution completed"

end