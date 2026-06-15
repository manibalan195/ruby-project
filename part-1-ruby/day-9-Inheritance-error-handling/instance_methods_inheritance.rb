class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def display
    puts "Point: #{@x}, #{@y}"
  end
end

class Point3D < Point
  def initialize(x, y, z)
    super(x, y)
    @z = z
  end

  def display
    super
    puts "Point3D: #{@x}, #{@y}, #{@z}"
  end
end

p = Point3D.new(10, 20, 30)
p.display