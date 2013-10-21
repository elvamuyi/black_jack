# /src/Action.rb
# This file defines the class for an action of a player.
# Usage example:
#   my_action = Action.new
#   puts "hit success!" if my_action.hit(hand, decks)
#   puts "stand success!" if my_action.stand
#   newhands = my_action.split(hand, decks)
#   puts "double_down success!" if my_action.double_down(hand, decks)

require File.dirname(__FILE__) + "/" + "Hand.rb"

class Action
  
  # Returns if hitting is successful
  def hit(hand, decks)
    if hand.is_bust || hand.is_21 || hand.is_doubledown
      puts "Cannot hit anymore!" 
      return false
    end
      hand.add_card(decks)
      return true
  end
  
  # Returns if standing is successful
  # Always true ("stand" needs doing nothing)
  def stand
    return true
  end
  
  # Returns a list of two hands if splitting is successful
  # Else returns original hand
  def split(hand, decks)
    if !hand.is_pair
      puts "Cannot split!"
      return hand
    end
    newhand1 = Hand.new([hand.get_card(0)], true, false)
    newhand1.add_card(decks)
    newhand2 = Hand.new([hand.get_card(1)], true, false)
    newhand2.add_card(decks)
    return [newhand1,newhand2]
  end
  
  # Returns if double down is successful
  def double_down(hand, decks)
    if !hand.is_two_cards
      puts "Cannot double_down!"
      return false
    end
    hand.add_card(decks)
    hand = Hand.new(hand.get_cards, false, true)
    return true
  end

end
