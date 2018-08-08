require_relative 'rangepiece.rb'
require_relative 'pawn.rb'
require_relative 'steppiece.rb'
require_relative 'nullpiece.rb'


class ChessGameErrors < StandardError; end
class UserInputErrors < ChessGameErrors; end


class Board

  attr_accessor :rows

  def initialize(rows=Array.new(8){Array.new(8)})
    @rows = rows
    @sentinel = NullPiece.instance
  end

  def populate
    @rows.each_with_index do |row ,i|
      row.each.with_index do |col ,j|
        if i == 0 && (j == 0 || j == 7)
          @rows[i][j] = RangePiece.new(:white, self, [i, j], :♖)
        elsif i == 7 && (j == 0 || j == 7)
          @rows[i][j] = RangePiece.new(:black, self, [i, j], :♜)
        elsif i == 1
          @rows[i][j] = Pawn.new(:white, self, [i, j], :♙)
        elsif i == 6
          @rows[i][j] = Pawn.new(:black, self, [i, j], :♟)
        elsif i == 0 && (j == 1 || j == 6)
          @rows[i][j] = StepPiece.new(:white, self, [i, j], :♘)
        elsif i == 7 && (j == 1|| j == 6)
          @rows[i][j] = StepPiece.new(:black, self, [i, j], :♞)
        elsif i == 0 && (j == 2 || j == 5)
          @rows[i][j] = RangePiece.new(:white, self, [i, j], :♗)
        elsif i == 7 && (j == 2 || j == 5)
          @rows[i][j] = RangePiece.new(:black, self, [i, j], :♝)
        elsif i == 0 && j == 3
          @rows[i][j] = StepPiece.new(:white, self, [i, j], :♔)
        elsif i == 7 && j == 3
          @rows[i][j] = StepPiece.new(:black, self, [i, j], :♚)
        elsif i == 0 && j == 4
          @rows[i][j] = RangePiece.new(:white, self, [i, j], :♕)
        elsif i == 7 && j == 4
          @rows[i][j] = RangePiece.new(:black, self, [i, j], :♛)
        else
          @rows[i][j] = @sentinel
        end
      end
    end
  end

  def [](pos)
    row,col = pos
    @rows[row][col]
  end

  def []=(pos,val)
    row,col = pos
    @rows[row][col] = val
  end

  def move_piece(color, start_pos, end_pos)
    raise ArgumentError.new("Empty Start Position") if self[start_pos].class == NullPiece
    raise ArgumentError.new("This isn't your piece") unless self[start_pos].color == color
    raise ArgumentError.new("A piece is already there") if self[end_pos].color == color
    duped = self.dup
    duped.move_piece!(color,start_pos, end_pos)
    raise ArgumentError.new("Can't move into Check") if duped.in_check?(color)
    raise ArgumentError.new("Invalid End position") unless self[start_pos].valid_moves.include?(end_pos)
    # if self[start_pos].class == Pawn && (start_pos[0]-end_pos[0]).abs == 2
    #   self[start_pos].en_passantable = true
    # elsif self[start_pos].class == Pawn
    #   self[start_pos].en_passantable = false
    # end
    # if self[start_pos].class == Pawn && self[end_pos].class == NullPiece && self[[end_pos[0], end_pos[1]]]
    #
    # end
    self[end_pos] = self[start_pos]
    self[start_pos] = @sentinel
    self[end_pos].has_moved = true
    self[end_pos].pos = end_pos
  end

  def move_piece!(color, start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = @sentinel
    self[end_pos].pos = end_pos
  end

  def valid_pos?(pos)
    x,y= pos.first, pos.last
    x.between?(0,7) && y.between?(0,7)
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def checkmate?(color)
    self.rows.each_with_index do |row|
      row.each_with_index do |col|
        next if col.class == NullPiece
        next if col.color != color
        col.valid_moves.each do |future_move|
          duped_board = self.dup
          duped_board.move_piece!(color, col.pos, future_move)
          return false unless duped_board.in_check?(color)
        end
      end
    end
    true
  end

  def in_check?(colour)
    king_pos = find_king(colour)
    self.rows.each_with_index do |row|
      row.each_with_index do |col|
        next if col.class == NullPiece
        next if col.color == colour
        return true if col.valid_moves.include?(king_pos)
      end
    end
    false
  end

  def find_king(color)
    self.rows.each_with_index do |row,i|
      row.each_with_index do |col,j|
        return [i,j] if self[[i,j]].symbol == :♔ || self[[i,j]].symbol == :♚ && self[[i,j]].color == color
      end
    end
  end

  def pieces
    pieces = []
    self.rows.each do |row|
      row.each do |col|
        if col.class != NullPiece
          pieces.push(col)
        end
      end
    end
    pieces
  end

  def dup
    dup_board = Board.new()
    dup_board.rows.each_with_index do |row,i|
      row.each_with_index do |col, j|
        dup_board.rows[i][j] = @sentinel
      end
    end
    pieceArray = self.pieces
    pieceArray.each do |piece|
      new_piece = piece.class.new(piece.color, dup_board, piece.pos, piece.symbol)
      dup_board[new_piece.pos]= new_piece
    end
    dup_board
  end

end
