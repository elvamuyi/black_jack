# /src/Dealer.rb
# This file defines the class for a player in the game.
# Dealer and Player are not inherited from a same class because
#   they are not much in common.
# Usage example:
#   my_player = Player.new(number)
#   puts my_player.to_s
#   my_player.restart

require File.dirname(__FILE__) + "/" + "Action.rb"

class Player
  
  # Creating a player with a number as player ID.
  # Each player starts with $1000, and no hands or bets.
  def initialize(number)
    @number = number
    @money = 1000
    @bets = []
    @hands = []
  end
  
  # Adding a bet to list of bets and update money.
  # At the same time adding a hand to list of hands.
  def add_bet(bet, hand)
    return false if bet > @money || bet < 1
    @bets << bet
    @money -= bet
    @hands << hand
    return true
  end
  
  # Doubling a bet in the list of bets with an index and update money.
  # Only used for double_down.
  def double_bet(i)
    return false if @bets[i] > @money
    @bets[i] *= 2
    @money -= @bets[i]
    return true
  end
  
  # Adding some amount of money.
  # Used for calculating game results.
  def add_money(amount)
    return false if amount < 0
    @money += amount
    return true
  end
  
  # Returns the ID of player.
  def get_number
    return @number
  end
  
  # Returns the money of player.
  def get_money
    return @money
  end
  
  # Returns a bet in the list of bets with an index.
  def get_bet(i)
    return @bets[i]
  end
  
  # Returns a hand in the list of hands with an index.
  def get_hand(i)
    return @hands[i]
  end
  
  # Returns all the hands in the list of hands.
  def get_hands
    return @hands
  end
  
  # Returns the index of a hand in the list of hands.
  def get_hand_index(hand)
    return @hands.index(hand)
  end
  
  # Returns information of the player (his ID and money).
  # Is a string.
  def to_s
    return "Player " + @number.to_s + ": You have $" + @money.to_s + " left."
  end
  
  # Clear the lists of bets and hands.
  # Used for starting another round of game.
  def restart
    @bets = []
    @hands = []
  end

end