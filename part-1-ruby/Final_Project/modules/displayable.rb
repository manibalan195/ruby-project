module Displayable
  def display
    puts "Title : #{title}"
    puts "Author : #{author}"
    puts "Year : #{year}"
    puts "-" * 30
  end

  def to_s
    "#{title} — #{author} (#{year})"
  end
end