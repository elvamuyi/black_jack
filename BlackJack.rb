# /BlackJack.rb
# This is the entry for the BlackJack game.

require File.dirname(__FILE__) + "/src/" + "Game.rb"

mygame = Game.new

begin
  mygame.get_bet
  mygame.round
end until mygame.get_players == []

puts "\nAll the players has left the table. Bye!"
