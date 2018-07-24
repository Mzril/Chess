require_relative 'piece.rb'
class RangePiece < Piece
  def initialize(color, board, pos, symbol)
    @symbol = symbol
    super(color, board, pos)
    move_dirs
  end
  
  def valid_moves
    valids = []
    @moves.each do |move|
      possible_move = vector(pos,move)
      while (possible_move.all? { |n| n.between?(0, 7) }) && (board[possible_move].symbol) == " "
        valids << possible_move
        possible_move = vector(possible_move,move)
      end
      
      if !possible_move.all? { |n| n.between?(0, 7) }
      elsif board[possible_move].color == @color
      else
        valids << possible_move
      end
    end  
    
    valids
  end
  
  protected
  def move_dirs
    diagonal_moves = [[1,1],[1,-1],[-1,1],[-1,-1]]
    straight_moves = [[0,1],[1,0],[-1,0],[0,-1]]
    if symbol == :R 
      @moves = straight_moves
    elsif symbol == :Q 
      @moves = diagonal_moves+straight_moves
    elsif symbol == :B
      @moves = diagonal_moves
    end 
    @moves      
  end
end