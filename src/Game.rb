# /src/Game.rb
# This file defines the class for a blackjack game.
# Usage example:
#   my_game = Game.new
#   mygame.get_bet
#   mygame.round

require File.dirname(__FILE__) + "/" + "Dealer.rb"
require File.dirname(__FILE__) + "/" + "Player.rb"

class Game
  
  # Initializing a game.
  def initialize
    puts "Welcome to Yining's BlackJack Game!"
    
    puts "\nHow many players are at the table (integer)?"
    @num_player = gets.chomp.to_i
    until @num_player > 0
      puts "Invalid input. Please enter again:"
      @num_player = gets.chomp.to_i
    end
    
    puts "How many decks do you want to use (integer 4 ~ 8)?"
    @num_decks = gets.chomp.to_i
    until @num_decks >= 4 && @num_decks <= 8
      puts "Invalid input. Please enter again:"
      @num_decks = gets.chomp.to_i
    end
    
    puts "\n------"
    puts "Game starting...\n"
    
    # Initializing some objects needed in game.
    @mydecks = Decks.new(@num_decks)
    @myaction = Action.new
    @mydealer = Dealer.new(@mydecks)
    @myplayers = []
    @num_player.times do |i|
      @myplayers << Player.new(i+1)
    end
    puts @myplayers
  end
  
  # Getting bets for a round from existing players
  def get_bet
    @myplayers.each do |one_player|
      helper_hand = Hand.new  # Helper hand used in Player.add_bet(bet, hand)
      puts "\n------"
      puts "Player " + one_player.get_number.to_s + \
        ": Please enter your bet (integer 1 ~ " + one_player.get_money.to_s + ")."
      bet = gets.chomp.to_i
      until one_player.add_bet(bet, helper_hand)
        puts "Invalid input. Please enter again:"
        bet = gets.chomp.to_i
      end
    end
  end
  
  # Input: player, hand, bet
  # When a player enters an action, his hands and bets change upon the action.
  def play(player, hand, bet)
    # A flag implying if the player should keep playing with the current hand.
    keep_playing = !hand.is_21
    
    while keep_playing
      puts "Please choose:\n 1(hit) 2(stand) 3(double down) 4(split)"
      choice = gets.chomp
      until ["1","2","3","4"].include?(choice)
        puts "Invalid input. Please enter again:"
        choice = gets.chomp
      end
      
      # Different actions.
      case choice
        
      # Hit
      when "1"
        if @myaction.hit(hand, @mydecks)
          puts "Your cards are: " + hand.to_s
          keep_playing = !hand.is_bust && !hand.is_21
        end
      
      # Stand
      when "2"
        if @myaction.stand
          puts "Your cards are: " + hand.to_s
          keep_playing = false
        end
        
      # double_down
      when "3"
        if !player.double_bet(player.get_hand_index(hand))
          puts "Money not enough for double_down."
          puts "Your cards are: " + hand.to_s
          keep_playing = true
        elsif !@myaction.double_down(hand, @mydecks)
          puts "Your cards are: " + hand.to_s
          keep_playing = true
        else
          puts "Your cards are: " + hand.to_s
          keep_playing = false
        end
        
      # split
      when "4"      
        newhands = @myaction.split(hand, @mydecks)
        if newhands != hand && player.add_bet(bet,newhands[1])
          hand.hand_change(newhands[0])
          newhands.each do |newhand|
            puts "\nYour cards are: " + newhand.to_s
            play(player, newhand, bet)
          end
          keep_playing = false
        elsif newhands == hand
          puts "Your cards are: " + hand.to_s
          keep_playing = true
        else
          puts "Money not enough for splitting."
          puts "Your cards are: " + hand.to_s
          keep_playing = true
        end
        
      end  # end of case choice    
    end    # end of while keep_playing
  end      # end of def play
  
  # Returns the ratio of bet that a player should win back.
  def win_back(player_hand, dealer_hand)
    if player_hand.is_bust
      return 0
    elsif player_hand.is_blackjack
      return 1 if dealer_hand.is_blackjack
      return 2.5
    else
      return 2 if dealer_hand.is_bust || 
          (player_hand.hand_score.max > dealer_hand.hand_score.max)
      return 0 if dealer_hand.is_blackjack || 
          (player_hand.hand_score.max < dealer_hand.hand_score.max)
      return 1
    end
  end
  
  # A round of game.
  def round
    puts "\n------"
    puts "Dealing cards..."
    puts "Dealer's cards: *, " + @mydealer.initial_status.to_s
    
    # Dealing 2 cards for each current player.
    @myplayers.each do |one_player|
      2.times do
        @myaction.hit(one_player.get_hand(0), @mydecks)
      end
      puts "\n------"
      puts one_player.to_s
      puts "Your cards are: " + one_player.get_hand(0).to_s
      play(one_player, one_player.get_hand(0), one_player.get_bet(0))
    end
    
    puts "\n------"
    puts "\nEnd of Playing. Here are results:"
    puts "Dealer's hand: " + @mydealer.final_status.to_s
    
    index_list = []  # Array of index of the player that should quit the game.
    delete_list = [] # Array of player that should quit the game.
    
    # Output the results for each player.
    @myplayers.each_with_index do |one_player, i|
      puts "\n--- Player " + one_player.get_number.to_s + " ---"
      puts "Your hand(s) are: \n"
      
      # Output the results for each hand of the player.
      one_player.get_hands.each_with_index do |one_hand, j|
        puts one_hand.to_s
        
        # Calculate the money that a player should win back and update the money
        money_back = win_back(one_hand, @mydealer.final_status) * one_player.get_bet(j)
        if one_player.add_money(money_back)
          puts "Money getting back: " + money_back.to_s
        end
      end
      
      puts one_player.to_s
      
      # Check if a player should quit the game and update the index array.
      if one_player.get_money <= 0
        index_list << i
        puts "You don't have enough money to continue. Bye!"
      else
        one_player.restart
      end
    end
    
    puts "\n------"
    puts "Round ends."
    @mydecks.renew_decks
    @mydealer = Dealer.new(@mydecks)
    
    # Delete players with no money from current players
    index_list.each {|i| delete_list << @myplayers[i]}
    @myplayers = @myplayers - delete_list
  end
  
  # Returns current players
  def get_players
    return @myplayers
  end
  
end