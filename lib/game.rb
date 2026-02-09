require_relative 'player'

class Game
  attr_accessor :player1, :player2

  def initialize
    @player1 = Player.new
    @player2 = Player.new
  end

  

  def get_player_name
    puts "Gimme player 1 name"
    player1.name = gets.chomp
    puts "Gimme player 2 name"
    player2.name = gets.chomp
  end

  def player1_name?
    "Bob"
  end

  def player2_name?
    "Rob"
  end
end