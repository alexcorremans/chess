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
      elsif input.match(regexp)
        choice[:type] = 'move'
        choice[:contents] = analyse(regexp)
        return choice
      else
        puts "Invalid input, please try again or type 'help' if you don't know what to do:"
        input = gets.chomp.downcase
      end
    end
  end

  def options
    %w{help save quit resign}
  end

  def regexp
  end

  def analyse(regexp)
    # return a hash with piece type and end point
  end
end