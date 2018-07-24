require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    @board.rows.each_with_index do |row,i|
      row.each_with_index do |col,j|
        if @cursor.cursor_pos == [i,j]
          printing = col.symbol.to_s
          print " #{printing}  ".colorize(background: :light_blue)
        else
          if (i + j) % 2 == 1
            printing = col.symbol.to_s.colorize(col.color)
            print " #{printing}  ".colorize(background: :light_black)
          elsif (i + j) % 2 == 0
            printing = col.symbol.to_s.colorize(col.color)
            print " #{printing}  ".colorize(background: :light_red)
          end
        end
      end
      puts ""
    end
  end

  def search_cursor
    a = nil
    while a.nil?
      system "clear"
      render
      a = @cursor.get_input
    end
    a
  end

end
