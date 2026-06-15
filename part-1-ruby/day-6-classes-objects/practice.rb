# Ruby classes are open
# You can reopen a class anytime and add new methods

class Calculator
  def add(a, b)
    a + b
  end
end

# Reopen the Calculator class and add a new method
class Calculator
  def subtract(a, b)
    a - b
  end
end

calc = Calculator.new
puts calc.add(5, 3)     
puts calc.subtract(5, 3) 

#----------------------------------------------------------------------------------
# Any Ruby program can add methods to existing classes

class String
  def greet
    "Hello #{self}"
  end
end

puts "Manibalan".greet

class Array
  def median
    sorted = self.sort
    len = sorted.length
    if len.odd?
      sorted[len / 2]
    else
      (sorted[len / 2 - 1] + sorted[len / 2]) / 2.0
    end
  end
end

puts [1, 2, 3, 4, 5].median

#----------------------------------------------------------------------------------

# Singleton methods to individual objects

str1 = "Mani"
str2 = "Bala"
def str1.greet
  "Hello #{self}"
end

puts str1.greet
puts str2.greet # This will raise an error since str2 does not have the greet method

#----------------------------------------------------------------------------------
#Duck typing

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    raise TypeError,
          "Point-like argument expected" unless
          other.respond_to?(:x) &&  # It check is the method x is defined for the other object
          other.respond_to?(:y)

    Point.new(@x + other.x, @y + other.y)
  end
end

#other solution using rescue
class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Point.new(@x + other.x, @y + other.y)
  rescue NoMethodError
    raise TypeError, "Point-like argument expected"
  end
end

#--------------------------------------------------------------------------------
# Implementing the [] operator for a class

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def [](index)
    case index
    when 0, -2
      @x
    when 1, -1
      @y
    when :x, "x"
      @x
    when :y, "y"
      @y
    else
      nil
    end
  end
end

point = Point.new(3, 4)
puts point[0]    # Output: 3
puts point["x"]    # Output: 3
puts point[:y]    # Output: 4

#--------------------------------------------------------------------------------
# Implementing the Enumerable module for a class

class Point
  include Enumerable # This allows us to use Enumerable methods like map, select, etc.

  def initialize(x,y)
    @x = x
    @y = y
  end

  def each # This method is required by the Enumerable module
    yield @x # This will send the x coordinate to the block
    yield @y
  end
end
point = Point.new(3, 4) 
puts point.each { |coord| puts coord } 

#---------------------------------------------------------------------------------

# Quick mutable classes using Struct

Point = Struct.new(:x, :y)
point = Point.new(3, 4)
puts point.x
point.y = 5 # Mutable, we can change the value of y
puts point.y

# struct with unmutable 
Point = Struct.new(:x, :y) 
point = Point.new(3, 4)

class Point
  undef x=
  undef y=
  undef []=
end
# point.x = 5  This will raise an error since x= method is undefined

#---------------------------------------------------------------------------------
#Class methods

class Calculator
  def self.add(*args) # or def Calculator.add(*args) 
    sum = 0
    args.each{ |i| sum += i } 
    sum
  end
end
puts Calculator.add(1, 2, 3) 

class << Calculator 
  def subtract(a, b)
    a - b
  end
end
puts Calculator.subtract(10, 2)

class Calculator
  class << self
    def multiply(*args)
      product = 1
      args.each{ |i| product *= i }
      product
    end
    def divide(a, b)
      a / b
    end
  end
end
puts Calculator.multiply(2, 3, 4)
puts Calculator.divide(12, 3)

#---------------------------------------------------------------------------------
# constants in classes

class Point
  ORIGIN = Point.new(0, 0) # This is a constant that represents the origin point (0, 0)
end

p1 = Point::ORIGIN
puts p1.x # Output: 0

#----------------------------------------------------------------------------------
# Class variables and class instance variables
class Counter
  @@count = 0 # Class variable shared among all instances

  def initialize
    @@count += 1
  end

  def self.count
    @@count
  end
end

puts Counter.count # Output: 0
Counter.new
puts Counter.count # Output: 1

class Counter
  @count = 0 # Class instance variable, not shared among instances

  class << self
    attr_accessor :count
  end

  def initialize
    self.class.count ||= 0 # Initialize count if it's nil
    self.class.count += 1
  end
end

puts Counter.count # Output: nil (not initialized)
Counter.new
Counter.new
puts Counter.count # Output: 2

#----------------------------------------------------------------------------------
