require_relative 'display.rb'
class Player 
  attr_reader :display, :color, :name
  def initialize(name,color,display)
    @name = name
    @color = color 
    @display = display
  end     
  
  def get_positions
    from_position = display.search_cursor
    puts "Move to ?"
    sleep 0.5
    to_position = display.search_cursor
    [from_position,to_position]
  end  
  
end  