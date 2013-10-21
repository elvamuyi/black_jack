# /src/Dealer.rb
# This file defines the class for a dealer in the game.
# Dealer and Player are not inherited from a same class because
#   they are not much in common.
# Usage example:
#   my_dealer = Dealer.new(decks)
#   puts my_dealer.initial_status
#   puts my_dealer.final_status

require File.dirname(__FILE__) + "/" + "Action.rb"

class Dealer
  
  # Creating a dealer with a set of decks for him to use.
  def initialize(decks)
    @decks = decks
    @action = Action.new
    @hand = Hand.new
  end
  
  # This is where the logic of the program differs from 
  #   that in a real game:
  #   A dealer has only two status.
  
  # The initial status of a dealer.
  # Only one of his card is revealed.
  def initial_status
    @action.hit(@hand, @decks)
    return @hand
  end

  # The final status of a dealer.
  # All of his card is revealed.
  def final_status
    @action.hit(@hand, @decks) until stop_hit(@hand)
    return @hand
  end
  
  # Returns whether the dealer hand should stop hitting.
  # The dealer must hit on 16 and soft 17, and stay on hard 17.
  def stop_hit(hand)
    return true if hand.is_bust
    return true if hand.hand_score == [17]
    return true if hand.hand_score.max > 17
    return false
  end

end