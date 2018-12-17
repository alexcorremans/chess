class Printer
  attr_reader :squares
  def initialize(squares)
    @squares = squares
  end

  def display(colour)
    case colour
    when 'white' then display_white
    when 'black' then display_black
    end
  end

  def display_white
    puts top_lines
    7.downto(0) do |y|
      puts (y+1).to_s + " " + white_row(y)
      puts y == 0 ? bottom_lines : middle_lines
    end
    puts bottom_row_white
    puts ""
  end

  def display_black
    puts top_lines
    0.upto(7) do |y|
      puts (y+1).to_s + " " + black_row(y)
      puts y == 7 ? bottom_lines : middle_lines
    end
    puts bottom_row_black
    puts ""
  end

  def white_row(y)
    row = ""
    0.upto(7) do |x|
      row += box(x,y)
    end
    row += vertical_line
  end

  def black_row(y)
    row = ""
    7.downto(0) do |x|
      row += box(x,y)
    end
    row += vertical_line
  end

  def bottom_row_white
    row = "   "
    0.upto(7) do |num|
      letter = (num + 97).chr
      row += letter + "  "
    end
    row
  end

  def bottom_row_black
    row = "   "
    7.downto(0) do |num|
      letter = (num + 97).chr
      row += letter + "  "
    end
    row
  end

  def box(a,b)
    boxify(squares.get_piece([a,b]))
  end


  def boxify(contents)
    result = convert(contents)
    "#{vertical_line}#{result} "
  end

  def convert(contents)
    return " " if contents.nil?
    type = contents.type.to_sym
    case contents.colour
    when 'white' then return white_pieces[type]
    when 'black' then return black_pieces[type]
    end
  end

  def white_pieces
    {
      rook:   "\u265C",
      knight: "\u265E",
      bishop: "\u265D",
      queen:  "\u265B",
      king:   "\u265A",
      pawn:   "\u265F"
    }
  end
  
  def black_pieces
    {
      rook:   "\u2656",
      knight: "\u2658",
      bishop: "\u2657",
      queen:  "\u2655",
      king:   "\u2654",
      pawn:   "\u2659"
    }
  end

  def vertical_line
    "\u2502"
  end

  def top_lines
    "  \u250c\u2500\u2500" + "\u252C\u2500\u2500"*7 + "\u2510"
  end
  
  def middle_lines
    "  \u251C\u2500\u2500" + "\u253C\u2500\u2500"*7 + "\u2524"
  end
    
  def bottom_lines
    "  \u2514\u2500\u2500" + "\u2534\u2500\u2500"*7 + "\u2518"
  end
end

