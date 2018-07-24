require_relative 'piece.rb' 
require 'singleton'
class NullPiece < Piece
  
  include Singleton
  
  def initialize
    
  end
  
  def moves
    
  end
  
  def symbol
    " "
  end
  
  def color 
    
  end  
  
end