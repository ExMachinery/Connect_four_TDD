require_relative 'player'
require_relative 'board'

class Game
  attr_accessor :player1, :player2

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @player_pick = 0
  end

  

  def get_player_name
    puts "Gimme player 1 name"
    player1.name = gets.chomp
    puts "Gimme player 2 name"
    player2.name = gets.chomp
  end

  def start_game
    get_player_name
    stop = false
    until stop
      play_sequence
      puts "Another one? Type Y - for yes, n - for no."
      valid = false
      until valid
        input = gets.chomp
        if input == "Y" 
          puts "Great!" 
          valid = true
        elsif input == "n" 
          stop = true 
          valid = true
        else 
          puts "Sorry, you need to type 'Y' or 'n'. Try again."
        end
      end
    end
    puts "Have a nice day!"
  end

  def play_sequence
    board = Board.new
    win = false
    turn = nil
    player_num = nil
    until win || win == nil
      if turn == @player2 || nil
        turn = @player1
        player_num = 1
      else
        turn = @player2
        player_num = 2
      end

      valid = false
      until valid
        clear
        board.render_board
        win = nil if board.draw?
        @player_pick = validate_pick(turn)
        if board.change_state(player_num, @player_pick) == nil
          puts "This column is full. Try another one"
        else
          valid = true
          win = board.win?(player_num, @player_pick)
        end
      end
    end
    clear
    puts "Congrats! #{turn.name} is a winner!" if win
    puts "Draw!" if win == nil
    board.render_board
  end

  def validate_pick(player)
    valid = false
    puts "#{player.name} your turn. Choose a column from 1 to 7"
    until valid
      input = gets.chomp
      if input.to_i > 0 && input.to_i <= 7
        valid = true
      else
        puts "Invalid input. Please, try again."
      end
    end
    return input.to_i
  end

  def clear
    system("clear")
  end

end