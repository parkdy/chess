require './piece'

class Board
  attr_accessor :rows

  DISPLAY_CHARS = { white: {King   => "\u2654".encode('utf-8'),
                            Queen  => "\u2655".encode('utf-8'),
                            Rook   => "\u2656".encode('utf-8'),
                            Bishop => "\u2657".encode('utf-8'),
                            Knight => "\u2658".encode('utf-8'),
                            Pawn   => "\u2659".encode('utf-8') },
                    black: {King   => "\u265A".encode('utf-8'),
                            Queen  => "\u265B".encode('utf-8'),
                            Rook   => "\u265C".encode('utf-8'),
                            Bishop => "\u265D".encode('utf-8'),
                            Knight => "\u265E".encode('utf-8'),
                            Pawn   => "\u265F".encode('utf-8') } }
  def initialize
    @rows = Array.new(8) { Array.new(8) }
    set_pieces
  end

  def [](pos)
    self.rows[pos[0]][pos[1]]
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

  def check?(color)

  end

  def move(start, finish)

  end

  def display

    # Row header
    puts "    " + ('a'..'h').to_a.join('   ')
    puts "  " + "-"*33

    @rows.each_with_index do |row, row_idx|
      # Column header
      print (8-row_idx).to_s + ' | '

      # Display square
      row.each do |square|
        if square.nil?
          print "  | "
        else
          print DISPLAY_CHARS[square.color][square.class] + ' | '
        end
      end
      puts "\n  " + "-"*33
    end

    nil
  end

end