
require_relative 'player.rb'
require_relative 'display.rb'
require 'byebug'
class Game

  attr_reader :board, :display,:p1,:p2, :currentplayer

  def initialize(board,display,p1,p2)
    @board=board
    @display=display
    @p1,@p2 = p1, p2
    @currentplayer = p1

  end

  def play
    until board.checkmate?(@currentplayer.color)
      take_turn
    end
    puts "#{@currentplayer.name} loses"
  end

  def notify_players
    puts "#{@currentplayer.name}'s turn!'"
  end

  def swap_turn
    @currentplayer == p1 ? @currentplayer = p2 : @currentplayer = p1
  end

  def take_turn
    notify_players
    sleep 0.75
    begin
      from, to = @currentplayer.get_positions
      board.move_piece(@currentplayer.color,from,to)
    rescue ArgumentError =>e
      puts e.message
      sleep 0.75
      retry
    end
    swap_turn
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new;
  b.populate;
  d = Display.new(b);
  p1 = Player.new("John",:black,d) ;
  p2 = Player.new("Dude",:white,d);
  puts "John is Black"
  puts "Dude is White"
  game = Game.new(b,d,p1,p2);
  count = 0
  until count == 10
    game.take_turn
    count += 1
  end
end
