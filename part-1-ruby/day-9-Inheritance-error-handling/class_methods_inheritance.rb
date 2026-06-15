class Animal
  def self.display
    puts "Class #{self}"
  end
end

class Dog < Animal
  def self.display
    super
    puts "Class #{self}"
  end
end

Dog.display
