require_relative 'piece.rb'
class StepPiece < Piece
  def initialize(color, board, pos, symbol)
    @symbol = symbol
    @has_moved = false
    super(color, board, pos)
    move_diffs
  end

  def move_diffs
    if @symbol == :N
      @moves = [[1,2], [2,1], [-2,1] ,[2,-1], [-1,2],[1,-2], [-2,-1], [-1,-2]]
    elsif @symbol == :K
      @moves = [[1,1], [-1,1], [-1,-1] ,[1,-1], [1,0],[-1,0], [0,-1], [0,1]]
    end
    @moves
  end
end
