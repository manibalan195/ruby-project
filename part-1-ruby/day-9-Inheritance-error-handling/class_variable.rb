class A
  @@shared = 1 
  @independent = 100

  def self.shared
    @@shared
  end

  def self.independent
    @independent
  end
end

class B < A
  @@shared = 2
  @independent = 200
end

puts "A Shared: #{A.shared}"
puts "B Shared: #{B.shared}"

puts "A Independent: #{A.independent}"
puts "B Independent: #{B.independent}"