# Chess
A simple game of Chess played through the Mac terminal

## How to play

## Prerequisites 

Need upto date version of bundler

1. Clone the folder with ```git clone https://github.com/Mzril/Chess.git```

2. run ```bundle install``` OR ```gem install colorize```

3. After install completion, run ```ruby game.rb```

Enjoy!

## Instructions

- Use the cursor and the enter key to select pieces and move them.

- Invalid moves will throw an error.

- Standard Chess rules are found [here](https://en.wikipedia.org/wiki/Rules_of_chess)

## Implementation 

### Checking for Checkmate 

One of the more tricky problems is to check if a given color is in checkmate if a player is in check. In order to do this, every possible move of every piece of the color in check must be performed in sequence, if even one of those board states are not in mate, the method must return false. This involves deep-duping the board for each possible move. Below is the code used to implement this.

```Ruby 
def dup
    #Creating the new Board
    dup_board = Board.new()
    dup_board.rows.each_with_index do |row,i|
      row.each_with_index do |col, j|
        dup_board.rows[i][j] = @sentinel
      end
    end
    pieceArray = self.pieces
    #Creating new pieces that each hold a reference to the new board 
    pieceArray.each do |piece|
      new_piece = piece.class.new(piece.color, dup_board, piece.pos, piece.symbol)
      dup_board[new_piece.pos]= new_piece
    end
    dup_board
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
```

### RangePieces and StepPieces

All pieces aside from the Pawn can be considered one of these two categories. RangePieces refer to the Rook, Bishop and Queen or those with move "directions". The Knight and King can be considered Steppieces due to their fixed tiles of movement. Below is the code for determining the valid moves for each.

```Ruby
def valid_moves
  ## Rangepiece valid moves
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
  if symbol == ♖ || ♜
    @moves = straight_moves
  elsif symbol == ♛ || ♕
    @moves = diagonal_moves+straight_moves
  elsif symbol == ♗ || ♝
    @moves = diagonal_moves
  end
  @moves
end

def valid_moves
  #StepPiece valid moves
  all_poss_moves = @moves.map do |move|
    vector(pos, move)
  end

  inbounds = all_poss_moves.select do |el|
    el.all? { |n| n.between?(0, 7) }
  end

  not_our_pieces = inbounds.select { |pos| self.board[pos].color != self.color || self.board[pos].class == NullPiece}
end

def move_diffs
  if @symbol == ♘ || @symbol == ♞
    @moves = [[1,2], [2,1], [-2,1] ,[2,-1], [-1,2],[1,-2], [-2,-1], [-1,-2]]
  elsif @symbol == ♔ || ♚
    @moves = [[1,1], [-1,1], [-1,-1] ,[1,-1], [1,0],[-1,0], [0,-1], [0,1]]
  end
  @moves
end
```

## Future Work 

- Implement Pawn Promotion

- Create a simple AI player 

- Move all the logic to React.js so that it is playable through the browser.


