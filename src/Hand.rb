# /src/Hand.rb
# This file defines the class for a hand in the game.
# Usage example:
#   my_hand = Hand.new

require File.dirname(__FILE__) + "/" + "Decks.rb"

class Hand

  # Create a hand of cards with existing cards (optional).
  # Two flags are associated with a hand:
  #   is_split: tells if a hand is created from splitting
  #   is_double_down: tells if a hand is created from double down
  def initialize(cards=[], is_split=false, is_double_down=false)
    @cards = cards
    @is_split = is_split
    @is_double_down = is_double_down
  end
  
  # Change the current hand to the input hand.
  def hand_change(hand)
    @cards = hand.get_cards
    @is_split = hand.is_splitted
    @is_double_down = hand.is_doubledown
  end

  # Returns the score of the hand in a blackjack game.
  # Is an array that contains possible values.
  def hand_score
    sum = [0]
    @cards.each do |one_card|
      temp = []
      one_card.score.each do |one_score|
        sum.each do |one_sum|
          temp << one_sum + one_score
        end
      end
      sum = temp
    end
    sum = sum.uniq                  # remove duplicate values
    return sum.select{|a| a <= 21}  # return valid values
  end
  
  # Returns if the hand is a bust.
  def is_bust
    # Because bust values are not valid, they are removed from hand_score
    # If a hand contains no valid values, it must be a bust.
    return hand_score.empty?  
  end

  # Returns if the hand is a blackjack.
  def is_blackjack
    return !@is_split && @cards.count == 2 && hand_score.include?(21)
  end
  
  # Returns if the hand is a pair.
  def is_pair
    return @cards.count == 2 && @cards[0].score == @cards[1].score
  end
  
  # Returns if the hand contains two cards.
  # Used in judging whether the hand could double down.
  def is_two_cards
    return @cards.count == 2
  end
  
  # Returns if the hand is created from double down.
  def is_doubledown
    return @is_double_down
  end
  
  # Returns if the hand is created from splitting.
  def is_splitted
    return @is_split
  end
  
  # Returns if the hand score is 21.
  def is_21
    return hand_score.include?(21)
  end

  # Returns information of the hand (its cards and scores).
  # Is a string.
  def to_s
    output = ""
    @cards.each {|one_card| output += one_card.to_s + ", "}
    if is_bust
      output << "BUST!"
    elsif is_blackjack
      output << "BLACKJACK!"
    else
      output << "Score = [" + hand_score.join(",") + "]"
    end
    return output
  end
  
  # Add a card to the current hand.
  def add_card(decks)
    return @cards if @is_double_down
    @cards << decks.draw_card
  end
  
  # Get a card from the current hand with an index.
  def get_card(index)
    return @cards[index]
  end

  # Get all cards from the current hand.
  def get_cards
    return @cards
  end

end