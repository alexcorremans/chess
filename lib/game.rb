class Game
  attr_reader :board, :white_player, :black_player, :current_player

  def initialize(board:, white_player:, black_player:)
    @board = board
    @white_player = white_player
    @black_player = black_player
    @current_player = white_player
  end

  def play
    loop do
      turn
      break if # check whether it's the end of the game (checkmate, stalemate)
      switch_players
    end    
  end

  private

  def turn
    display
    puts "It's your turn, #{player_name}!"
    loop do
      feedback = get_player_feedback
      break if feedback == 'moved'
      if feedback == 'help'
        help
      elsif feedback == 'save'
        save
      elsif feedback == 'quit'
        quit
      elsif feedback == 'resign'
        resign
      end
    end
  end

  def switch_players
    current_player == black_player ? white_player : black_player
  end

  def display
    board.display(team)
  end
  
  def team
    current_player.team
  end

  def player_name
    current_player.name
  end

  def get_player_feedback
    current_player.play(board)
  end

  def help
    puts <<~INSTRUCTIONS
      To move one of your pieces, please type the name of the piece followed by the name 
      of the square you want to move it to, for example 'knight to c3'. 
      If you want to move a pawn, you can also just type the name of a square, like 'e4'.
      
      You can also enter any of the following at any time:
      - enter 'resign' to resign from the game
      - enter 'save' to save the game
      - enter 'quit' to stop playing
      - enter 'help' to see these instructions again.
    INSTRUCTIONS
  end

  def save
    puts "Enter a filename so you can retrieve your saved game later:"
    filename = gets.chomp.downcase
    File.open("../saved_games/#{filename}.yml", "w") do |file|
      file.write(YAML.dump(self))
    end
    puts "Game saved."
  end

  def quit
    puts "Make sure you've saved your game before quitting if you want to come back to it later!"
    puts "Are you sure you want to exit the game (y/n)?"
    input = gets.chomp.downcase
    loop do
      if input == 'y'
        exit
      elsif input == 'n'
        break
      else
        puts "Please enter 'y' to exit or 'n' to go back"
        input = gets.chomp.downcase
      end
    end    
  end

  def resign
    # to be implemented
    exit
  end

  def checkmate
  end

  def stalemate
  end
end