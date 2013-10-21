# /src/Card.rb
# This file defines the class for poker cards.
# Usage example:
#   my_card = Card.new(suit, value)
#   puts my_card.score
#   puts my_card.to_s

class Card

  # A card has a suit and a value
  def initialize(suit, value)
    @suit = suit;
    @value = value;
  end

  # Returns the score of a card in the BlackJack game.
  # Is an array that contains possible values.
  def score
    return [10] if ["J", "Q", "K"].include?(@value)
    return [1,11] if @value == "A"
    return [@value]
  end

  # Returns information of the card.
  # Is a string.
  def to_s
    return @value.to_s + "-" + @suit.to_s
  end

end