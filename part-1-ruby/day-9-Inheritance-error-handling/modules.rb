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

module Searchable
  def find_by_title(query)
    @books.find { |b| b.title.downcase.include?(query.downcase) }
  end

  def find_by_author(query)
    @books.select { |b| b.author.downcase.include?(query.downcase) }
  end
end

module Exportable
  def to_csv_row(query)
    book = find(query)

    return "Book not found" unless book

    title = book.title.include?(",") ? "\"#{book.title}\"" : book.title
    author = book.author.include?(",") ? "\"#{book.author}\"" : book.author

    "#{title}, #{author}, #{book.year}, #{book.genre}"

  end
end