require 'pry'

class Participant
  attr_reader :name
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def busted?
    total > 21
  end

  def total
    result = cards.map(&:score).reduce(:+)

    num_aces = cards.count { |card| card.value == 'Ace' }
    while num_aces > 0 && result > 21
      result -= 10
      num_aces -= 1
    end
    result
  end

  def show_cards
    if cards.size == 2
      puts "#{name} has #{cards.join(' and ')}."
    else
      puts "#{name} has #{cards[0..-2].join(', ')}, and #{cards[-1]}."
    end
  end

  def to_s
    name
  end

  def show_total
    result = "#{self} has a total of #{total}."
    result << " #{self} busted!" if busted?
    puts result
  end

  def show_busted_or_stayed
    if busted?
      puts "#{self} busted with a total of #{total}."
    else
      puts "#{self} stayed with a total of #{total}."
    end
  end
end

class Player < Participant
  def initialize
    super
    @name = set_name
  end

  def set_name
    name = nil
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry, you must enter a value."
    end
    name
  end

  def show_initial_cards
    show_cards
  end

  def hit?
    answer = nil
    loop do
      puts "Do you want to hit or stay?"
      answer = gets.chomp.downcase
      break if %w[hit stay].include?(answer)
      puts "Sorry, that's not a valid choice. You must choose 'hit' or 'stay'."
    end
    answer == 'hit'
  end
end

class Dealer < Participant
  def initialize
    super
    # seems like very similar to Player... do we even need this?
    @name = "Dealer"
  end

  def show_initial_cards
    puts "#{name} has #{cards[0]} and ?"
  end
end

class Deck
  VALUES = (2..9).to_a + %w[Jack Queen King Ace]
  SUITS = %w[Hearts Clubs Diamonds Spades]

  def initialize
    @cards = VALUES.product(SUITS).map do |value, suit|
      Card.new(value, suit)
    end
    @cards.shuffle!
  end

  def deal_card(participant)
    participant.cards << @cards.shift
  end
end

class Card
  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "the #{value} of #{suit}"
  end

  def score
    case value
    when 2..9
      value
    when 'Jack', 'Queen', 'King'
      10
    when 'Ace'
      11
    end
  end
end

class Game
  attr_reader :dealer, :player, :deck

  def initialize
    reset
  end

  def start
    loop do
      system 'clear'
      deal_cards
      show_initial_cards
      player_turn
      player.show_busted_or_stayed
      dealer_turn unless player.busted?
      show_result
      break unless play_again?
      reset
    end
    puts "Thanks for playing Twenty-One! Arrivederci!"
  end

  private

  def deal_cards
    2.times do
      deck.deal_card(dealer)
      deck.deal_card(player)
    end
  end

  def show_initial_cards
    player.show_initial_cards
    dealer.show_initial_cards
  end

  def player_turn
    puts "#{player}'s turn..."
    loop do
      break unless player.hit?
      deck.deal_card(player)
      puts "#{player} hits!"
      player.show_cards
      break if player.busted?
    end
  end

  def dealer_turn
    puts "#{dealer}'s turn..."
    while dealer.total < 17
      puts "#{dealer} hits!"
      deck.deal_card(dealer)
    end
    dealer.show_busted_or_stayed
  end

  def show_result
    puts
    player.show_cards
    player.show_total
    dealer.show_cards
    dealer.show_total
    if winner
      puts "#{winner} wins!"
    else
      puts "It's a tie!"
    end
  end

  def winner
    return winner_if_someone_busted if winner_if_someone_busted

    if dealer.total > player.total
      dealer
    elsif player.total > dealer.total
      player
    end
  end

  def winner_if_someone_busted
    if player.busted?
      dealer
    elsif dealer.busted?
      player
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Sorry, you must choose 'y' or 'n'."
    end
    answer == 'y'
  end

  def reset
    @dealer = Dealer.new
    @player = Player.new
    @deck = Deck.new
  end
end

Game.new.start
