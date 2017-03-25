require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
                   [1, 5, 9], [3, 5, 7]]            # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+------"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+------"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def lines_where_marker_can_win(marker)
    WINNING_LINES.select do |line|
      squares = @squares.values_at(*line)
      markers = squares.collect(&:marker)
      markers.count(marker) == 2 && squares.count(&:unmarked?) == 1
    end
  end

  def unmarked_key_on_line(line_keys)
    line_keys.detect { |key| @squares[key].unmarked? }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :score, :name

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def score_string
    if score == 1
      "1 point"
    else
      "#{score} points"
    end
  end

  def to_s
    name
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER
  # FIRST_TO_MOVE = 'choose'
  WINNING_SCORE = 5
  LET_HUMAN_CHOOSE_MARKER = false

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    setup

    loop do
      loop do
        set_first_mover
        play_round
        break if someone_won_game?
        prompt_to_continue
        reset
      end
      display_game_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def setup
    clear
    display_welcome_message
    human_chooses_marker if LET_HUMAN_CHOOSE_MARKER
    set_player_names
  end

  def play_round
    display_board
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end

    display_result
    update_scores
    display_scores
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_board
    puts "#{human.name} is a #{human.marker}. " \
      + "#{computer} is a #{computer.marker}."
    puts
    board.draw
    puts
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[best_compute_square] = computer.marker
  end

  def best_computer_square
    return computers_defensive_move if computers_defensive_move
    return computers_winning_move if computers_winning_move
    if board.unmarked_keys.include?(5)
      5
    else
      board.unmarked_keys.sample
    end
  end

  def computers_defensive_move
    immediate_threats = board.lines_where_marker_can_win(human.marker)
    board.unmarked_key_on_line(immediate_threats.sample) \
      if immediate_threats.any?
  end

  def computers_winning_move
    opportunities_to_win = board.lines_where_marker_can_win(computer.marker)
    board.unmarked_key_on_line(opportunities_to_win.sample) \
      if opportunities_to_win.any?
  end

  # def immediate_threats
  #   board.lines_where_marker_can_win(human.marker)
  # end

  # def opportunities_to_win
  #   board.lines_where_marker_can_win(computer.marker)
  # end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def round_winner
    case board.winning_marker
    when human.marker
      human
    when computer.marker
      computer
    end
  end

  def display_result
    clear_screen_and_display_board

    case round_winner
    when human
      puts "#{human} won!"
    when computer
      puts "#{computer} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include? answer
      puts "Sorry, you must choose 'y' or 'n'."
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    reset_scores
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def joinor(array, delimiter=', ', conjunction='or')
    case array.size
    when 0 then ''
    when 1..2 then array.join(" #{conjunction} ")
    else
      array_copy = array.dup
      array_copy[-1] = "#{conjunction} #{array[-1]}"
      array_copy.join(delimiter)
    end
  end

  def update_scores
    round_winner.score += 1 if round_winner
  end

  def display_scores
    puts "#{human} has #{human.score_string}. " \
      "#{computer} has #{computer.score_string}."
  end

  def someone_won_game?
    !!game_winner
  end

  def game_winner
    if human.score >= 5
      human
    elsif computer.score >= 5
      computer
    end
  end

  def display_game_result
    case game_winner
    when human
      puts "#{human} won the game!"
    when computer
      puts "#{computer} won the game!"
    end
  end

  def prompt_to_continue
    puts "Press ENTER to continue"
    gets.chomp
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def set_first_mover
    if FIRST_TO_MOVE == 'choose'
      @current_marker = human_wants_first_move? ? HUMAN_MARKER : COMPUTER_MARKER
    else
      @current_marker = FIRST_TO_MOVE
    end
  end

  def human_wants_first_move?
    answer = nil
    loop do
      puts 'Do you want to move first? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Sorry, you must choose 'y' or 'n'."
    end
    answer == 'y'
  end

  def human_chooses_marker
    answer = nil
    loop do
      puts "Enter a capital letter that you want to be your marker."
      answer = gets.chomp
      break if answer =~ /\A[A-Z]\z/
      puts "Sorry's, that's not a valid choice."
    end
    human.marker = answer
    computer.marker = (('A'..'Z').to_a - [human.marker]).sample
  end

  def set_player_names
    computer.name = ['Hal', 'Deep Blue', 'Watson'].sample

    human_name = nil
    loop do
      puts "What's your name?"
      human_name = gets.chomp
      break unless human_name.empty?
      puts "Sorry, you must enter a value."
    end
    human.name = human_name
  end
end

game = TTTGame.new
game.play
