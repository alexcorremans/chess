require_relative 'config'
require_relative 'boardfactory'

def new_game
  board = BoardFactory.build
  white = Player.new(colour: "white")
  black = Player.new(colour: "black")
  game = Game.new(board, white, black)
  game.play
end

def saved_game
  puts "What name did you save your game as?"
    begin
      filename = gets.chomp.downcase
      game = YAML.load_file("saved_games/#{filename}.yml")
      game.play
    rescue
      puts "No saved files with that name. Try again:"
      retry
    end
end
    

puts "Welcome to Chess!"

if Dir["saved_games/*"].empty?
  new_game  
else
  puts "Type 'new' to play a new game or 'saved' to open a previously saved game."
  choice = gets.chomp.downcase
  until choice == "new" || choice == "saved"
    puts "Not a valid choice, choose 'new' or 'saved':"
    choice = gets.chomp.downcase
  end
  choice == "new" ? new_game : saved_game
end


