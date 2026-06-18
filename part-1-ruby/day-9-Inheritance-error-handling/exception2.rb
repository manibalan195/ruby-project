def c
  raise 
end

def b
  c
end

def a
  begin
    b
  rescue
    puts "rescued"
    raise
  end
end

begin
  a
rescue 
  puts "re-raised"
end
