# Problem description: Two players take turns marking squares on a 3x3 board. One player uses the marker X; the other uses the marker O. A player wins when they have marked three squares in a row (horizontally, vertically, or diagonally) with their marker. If the board is filled before either player has won, the result is a tie.

# Nouns: player, squares, board, marker, row, tie
# Verbs: mark, fill, win

'''
Board

Square

Player
- mark
- play
'''

class Board
  def initialize
    # we need some way to model the 3x3 grid. Maybe "squares"?
    # what data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integers?   
  end
end

class Square
  def initialize
    
  end
end

class Player
  def initialize
    # marker to keep track of the player's symbol
  end

  def mark
    
  end
end

class TTTGame
  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_won? || board_full?

      second_player_moves
      break if someone_won? || board_full?
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
