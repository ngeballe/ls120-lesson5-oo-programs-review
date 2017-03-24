require 'pry'

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
  attr_reader :squares

  EMPTY_MARKER = ' '
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  def initialize
    # we need some way to model the 3x3 grid. Maybe "squares"?
    # what data structure should we use?
    # - array/hash of Square objects?
    # - array/hash of strings or integers?  
    @squares = { 1 => EMPTY_MARKER, 2 => EMPTY_MARKER, 3 => EMPTY_MARKER,
                 4 => EMPTY_MARKER, 5 => EMPTY_MARKER, 6 => EMPTY_MARKER,
                 7 => EMPTY_MARKER, 8 => EMPTY_MARKER, 9 => EMPTY_MARKER }
  end

  def display
    puts "     |     |     "
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]} "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]} "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]} "
    puts "     |     |     "
  end

  def empty_squares
    squares.select { |num, value| value == ' ' }.keys
  end

  def []=(square_num, marker)
    squares[square_num] = marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      values = squares.values_at(*line)
      if values.uniq.size == 1 && values[0] != EMPTY_MARKER
        return values[0]
      end
    end
    nil
  end
end

class Square
  def initialize
    
  end
end

class Player
  attr_reader :name, :marker

  def initialize(marker)
    set_name
    @marker = marker
  end

  # def mark_square(board)
  #   @empty_squares = board
  # end
end

class Human < Player
  def set_name
    name = ''
    loop do
      print 'Please enter your name: '
      name = gets.chomp
      break unless name.empty?
      puts "You must enter a value."
    end
    @name = name
  end

  def mark_square(board)
    empty_squares = board.empty_squares
    available_squares_string = if empty_squares.size < 2
                                 empty_squares.join(' or ')
                               else
                                 empty_squares[0..-2].join(", ") + ", or #{empty_squares[-1]}"
                               end
    choice = nil
    loop do
      puts "Please mark a square (#{available_squares_string})."
      choice = gets.chomp.to_i
      break if empty_squares.include?(choice)
      puts "Sorry, that's not a valid choice."
    end
    board[choice] = marker
  end
end

class Computer < Player
  def set_name
    @name = ['Hal', 'Deep Blue', 'Old Junky'].sample
  end

  def mark_square(board)
    choice = board.empty_squares.sample
    board[choice] = marker
  end
end

class TTTGame
  attr_reader :board, :computer, :human

  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  def initialize
    @board = Board.new
    @human = Human.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_board
    system 'clear'
    board.display
  end

  def first_player_moves
    human.mark_square(board)
  end

  def second_player_moves
    computer.mark_square(board)
  end

  def board_full?
    board.empty_squares.size == 0
  end

  def winner
    case board.winning_marker
    when human.marker
      human
    when computer.marker
      computer
    end
  end

  def someone_won?
    !!winner
  end

  def display_result
    display_board
    if winner
      puts "#{winner.name} won!"
    else
      puts "It's a tie."
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

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
