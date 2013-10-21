# /src/Decks.rb
# This file defines the class for a set of poker decks used in the game.
# Usage example:
#   my_decks = Decks.new(number_of_decks)
#   puts my_decks.draw_card
#   my_decks.renew_decks

require File.dirname(__FILE__) + "/" + "Card.rb"

class Decks

  # A set of decks. The number of decks are required for input.
  # Cards are shuffled.
  def initialize(number_of_decks)
    @cards = []
    number_of_decks.times do
      [:Heart,:Spade,:Club,:Diamond].each do |suit|
        [2,3,4,5,6,7,8,9,10,'J','Q','K','A'].each do |value|
          @cards << Card.new(suit, value)
        end
      end
    end
    @cards = @cards.shuffle
    @num_decks = number_of_decks
  end

  # Returns the first card in the set.
  def draw_card
    return @cards.shift
  end

  # When the set of cards are less than a deck, create a new set.
  def renew_decks
    if @cards.count < 52
      @cards = Decks.new(@num_decks)
    end
  end

end