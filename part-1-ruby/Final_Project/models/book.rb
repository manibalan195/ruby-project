require_relative "../modules/displayable"

class Book
  include Displayable
  include Comparable

  attr_reader :title, :author, :year

  def initialize(title, author, year)
    @title = title
    @author = author
    @year = year
  end

  def <=>(other)
    return nil unless other.is_a?(Book)
    @year <=> other.year
  end
  
  def genre
    "N/A"
  end
end
