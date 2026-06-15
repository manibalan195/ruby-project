class Student
  attr_accessor :name,:mark

  def initialize(name,mark) # constructor also private method but it can be called by the class itself
    @name = name
    @mark = mark
  end

  def compare_mark(other) # public method
    puts calculate_result # it can call private method within the class
    other.mark > self.mark # it can call protected method of other instance of the same class
  end

  protected # protected method can be called by any instance of the same class or its subclasses
  def mark
    @mark
  end

  private # private method can only be called within the context of the current instance
  def calculate_result
    mark >= 50 ? "pass" : "fail"
  end
end

s1 = Student.new("mani", 85)
s2 = Student.new("bala", 45)
puts s1.compare_mark(s2) # public method can be called from outside the class

#----------------------------------------------------------------------------------
# Factory method pattern

class Point
  attr_accessor :x, :y
  private_class_method :new # make the constructor private

  def initialize(x, y)
    @x = x
    @y = y
  end

  def self.create_origin
    new(0, 0) # it can call private constructor within the class
  end
end

#origin = Point.new(0, 0) # This will raise an error since the constructor is private
origin = Point.create_origin

#----------------------------------------------------------------------------------

# private and protected methods does not gives full privacy

class Person
  def initialize(name)
    @name = name
  end

  private
  def name
    @name
  end
end

p = Person.new("Alice")
# puts p.name # This will raise an error since name is a private method
puts p.send(:name) # send does not check method visibility 
puts p.instance_eval{ name } # makes the block execute as if it were inside the object itself.