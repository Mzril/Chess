# require_relative 'rangepiece.rb'
# require_relative 'pawn.rb'
# require_relative 'steppiece.rb'
# require_relative 'nullpiece.rb'
require_relative 'vector.rb'
require 'byebug'

class Piece
  include Vector
  attr_accessor :pos
  attr_reader :color, :moves, :board, :has_moved
  def initialize(color, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def valid_moves
    all_poss_moves = @moves.map do |move|
      vector(pos, move)
    end

    inbounds = all_poss_moves.select do |el|
      el.all? { |n| n.between?(0, 7) }
    end

    not_our_pieces = inbounds.select { |pos| self.board[pos].color != self.color || self.board[pos].class == NullPiece}

    if self.class == Pawn
      pawn_moves = not_our_pieces.dup
      pawn_moves.each do |move|
        if move[1] == self.pos[1] && board[move].class != NullPiece && board[move].color != color
          not_our_pieces.delete(move)
        elsif move[1] != self.pos[1] && board[move].class == NullPiece
          not_our_pieces.delete(move)
        end
      end
      unless self.has_moved
        if self.color == :white
          not_our_pieces.push([self.pos[0]+2, self.pos[1]]) unless board[[self.pos[0]+2, self.pos[1]]].class != NullPiece
        elsif self.color == :black
          not_our_pieces.push([self.pos[0]-2, self.pos[1]]) unless board[[self.pos[0]-2, self.pos[1]]].class != NullPiece
        end
      end
    end
    not_our_pieces
   end

  def pos=(val)
    @pos = val
  end

  def symbol
    @symbol
  end

  private
  def move_into_check?(end_pos)

  end
end
