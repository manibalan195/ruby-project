module Exportable
  def to_csv_row(query)
    book = find_by_title(query)

    return "Book not found" unless book

    title = book.title.include?(",") ? "\"#{book.title}\"" : book.title
    author = book.author.include?(",") ? "\"#{book.author}\"" : book.author

    "#{title}, #{author}, #{book.year}, #{book.genre}"

  end
end