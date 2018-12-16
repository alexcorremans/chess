require 'yaml'
%w{config boardfactory player game}.each do |file|
  require_relative "lib/#{file}"
end

def new_game
  puts "Let's play chess!"
  board = BoardFactory.build
  white = Player.new(team: "white")
  black = Player.new(team: "black")
  game = Game.new(board: board, white_player: white, black_player: black)
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

if Dir["saved_games/*"].empty?
  new_game  
else
  puts "Welcome back!"
  puts "Type 'new' to play a new game or 'saved' to open a previously saved game."
  choice = gets.chomp.downcase
  until choice == "new" || choice == "saved"
    puts "Not a valid choice, choose 'new' or 'saved':"
    choice = gets.chomp.downcase
  end
  choice == "new" ? new_game : saved_game
end


