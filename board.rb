# encoding: UTF-8
require './piece'
require 'colorize'



class Board
  attr_accessor :rows
  

  DISPLAY_CHARS = { white: {King   => '♔',
                            Queen  => '♕',
                            Rook   => '♖',
                            Bishop => '♗',
                            Knight => '♘',
                            Pawn   => '♙' },
                    black: {King   => '♚',
                            Queen  => '♛',
                            Rook   => '♜',
                            Bishop => '♝',
                            Knight => '♞',
                            Pawn   => '♟' } }


  def initialize
    @rows = Array.new(8) { Array.new(8) }
  end


  def dup
    duplicate = Board.new

    self.rows.each_with_index do |row,row_num|
      row.each_with_index do |square, col_num|
        if square.nil?
          duplicate[[row_num, col_num]] = nil
        else
          duplicate[[row_num, col_num]] = square.dup(duplicate)
        end
      end
    end

    duplicate
  end


  def [](pos)
    unless self.in_bounds?(pos)
      raise ArgumentError.new("Position out of bounds")
    end
    self.rows[pos[0]][pos[1]]
  end


  def []=(pos, val)
    unless self.in_bounds?(pos)
      raise ArgumentError.new("Position out of bounds")
    end
    self.rows[pos[0]][pos[1]] = val
  end


  def in_bounds?(pos)
    row, col = pos
    row.between?(0,7) && col.between?(0,7)
  end


  def set_pieces
    # Black pawns
    self.rows[1].each_index do |col|
      self.rows[1][col] = Pawn.new(:black, [1, col], self)
    end

    # White pawns
    self.rows[6].each_index do |col|
      self.rows[6][col] = Pawn.new(:white, [6, col], self)
    end

    class_names = [Rook, Knight, Bishop, Queen,
                   King, Bishop, Knight, Rook]

    # Black major pieces
    class_names.each_with_index do |class_name, col|
      self.rows[0][col] = class_name.new(:black, [0,col], self)
    end

    # White major pieces
    class_names.each_with_index do |class_name, col|
      self.rows[7][col] = class_name.new(:white, [7,col], self)
    end
  end


  def pieces(color)
    pieces = []
    self.rows.each do |row|
      row.each do |square|
        pieces << square if square.is_a?(Piece) && square.color == color
      end
    end

    pieces
  end


  # Did player with color 'color' win?
  def checkmate?(color)
    opponent = ( color == :black ? :white : :black )

    self.pieces(opponent).each do |piece|
      return false if piece.valid_moves.any?
    end
    true
  end


  # color is in check
  def checked?(color)
    king = pieces(color).select { |piece| piece.is_a?(King) }[0]
    king_pos = king.position

    enemy = (color == :white ? :black : :white)
    enemy_pieces = pieces(enemy)
    enemy_pieces.each do |piece|
      return true if piece.moves.include?(king_pos)
    end

    false
  end


  def move!(start, finish)
    piece = self[start]
    self[start] = nil
    self[finish] = piece
    piece.position = finish
  end


  def move(start, finish)
    unless self.in_bounds?(start) && self.in_bounds?(finish)
      raise ArgumentError.new("Positions out of bounds")
    end

    raise ArgumentError.new("No piece to move") if self[start].nil?
    piece = self[start]
    unless piece.valid_moves.include?(finish)
      raise ArgumentError.new("Cannot move there!")
    end

    move!(start, finish)
  end


  def pawn_to_be_promoted
    8.times do |col|
      self.rows[0].each do |sqr|
        return sqr if sqr.is_a?(Pawn) && sqr.color == :white
      end
      self.rows[7].each do |sqr|
        return sqr if sqr.is_a?(Pawn) && sqr.color == :white
      end
    end
    nil
  end


  def promote(pawn, color, piece_class)
    pos = pawn.position
    self[pos] = piece_class.new(color, pos, self)
  end


  def display
    # Row header
    puts ("    " + ('a'..'h').to_a.join('  ') + "    ").colorize(:color => :light_white,
                                                                 :background => :black)

    @rows.each_with_index do |row, row_idx|
      # Column header
      print (' ' + (8-row_idx).to_s + ' ').colorize(:color => :light_white,
                                                    :background => :black)

      # Display square
      row.each_with_index do |square, col_idx|
        char = " "
        if square.nil?
          char = "   "
        else
          char = " " + DISPLAY_CHARS[square.color][square.class] + " "
        end
        if (row_idx + col_idx) % 2 == 1
          char = char.colorize(:background => :cyan)
        else
          char = char.colorize(:background => :light_white)
        end

        print char
      end

      print (' ' + (8-row_idx).to_s + ' ').colorize(:color => :light_white,
                                                    :background => :black)
      puts

    end

    puts ("    " + ('a'..'h').to_a.join('  ') + "    ").colorize(:color => :light_white,
                                                                 :background => :black)

    nil
  end
end