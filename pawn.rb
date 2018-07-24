require_relative 'piece.rb'
class Pawn < Piece
  attr_reader :forward_dir
  def initialize(color, board, pos, symbol)
    @symbol = symbol
    super(color, board, pos)
    @forward_dir = -1 if @color == :black
    @forward_dir = 1 if @color == :white
    move_dirs
  end
  
  def move_dirs
    @moves = [[1, 0], [1, 1], [1, -1]]
    @moves = @moves.map do |el|
      el.map do |el2|
        el2 * @forward_dir
      end
    end
  end
  
  
  private
  def at_start_row?
    
  end
  
  def forward_steps
    
  end
  
  def side_attacks
    
  end
end