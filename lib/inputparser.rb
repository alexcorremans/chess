module InputParser
  extend self

  def get_input
    puts "Please enter your move or type 'help' for more instructions:"
    choose
  end

  def choose
    choice = {}
    input = gets.chomp.downcase
    loop do
      if options.include?(input)
        choice[:type] = 'other'
        choice[:contents] = input
        return choice
      elsif !move_parse(input).nil?
        choice[:type] = 'move'
        choice[:contents] = move_parse(input)
        return choice
      else
        puts "Invalid input, please try again or type 'help' if you don't know what to do:"
        input = gets.chomp.downcase
      end
    end
  end

  def has_coordinates?(input)
    input =~ regexp
  end

  def move_parse(input)
    return nil unless has_coordinates?(input)
    endpoint = get_endpoint(input)
    piece_type = get_piece(input)
    return nil if piece_type.nil?
    { 
      endpoint: endpoint, 
      piece_type: piece_type
    }
  end

  def get_endpoint(input)
    coordinates = input[regexp].split(/\s?/)
    endpoint = convert(coordinates)
  end

  def get_piece(input)
    input = input.sub(input[regexp], '').sub(/to/, '').strip
    if pieces.include?(input)
      return input
    elsif input == ''
      return 'pawn'
    else
      return nil
    end
  end

  def convert(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    x = translations[x.downcase]
    y = y.to_i - 1
    [x,y]
  end

  def options
    %w{help save quit resign}
  end
  
  def regexp
    /[a-hA-H]\s?[1-8]/
  end

  def pieces
    %w{pawn rook knight bishop queen king}
  end

  def translations
    {
      'a' => 0,
      'b' => 1,
      'c' => 2,
      'd' => 3,
      'e' => 4,
      'f' => 5,
      'g' => 6,
      'h' => 7
    }
  end
end