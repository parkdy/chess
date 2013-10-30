require './prompt'

class Player
  attr_accessor :color, :board

  def initialize(color, board)
    @color = color
    @board = board
  end

  def display
    #To do
  end
end

class HumanPlayer < Player

  def valid_position_input?(input)
    raise RuntimeError.new("Invalid input: Only 2 letters") unless input.length == 2
    raise RuntimeError.new("Invalid input: File must be a-h") unless input[0].between?('a','h')
    raise RuntimeError.new("Invalid input: Rank must be 1-8") unless input[1].between?('1','8')
    true # if you got through the gauntlet
  end

  def play_turn
    begin #start input
      print "Enter position of piece to move: "
      start_str = gets.chomp

      valid_position_input?(start_str)
      start = translate_input(start_str)

      piece = self.board[start]

      if piece.nil? #start square can't be a nil piece
        raise RuntimeError.new("Invalid input: Not a piece.")
      end

      unless piece.color == self.color #is the player's color,
        raise RuntimeError.new("Invalid input: Piece is not your color.")
      end

      unless piece.valid_moves.any? # is a piece that can move.
        raise RuntimeError.new("Invalid input: Piece has no valid moves.")
      end


    rescue RuntimeError => e
      puts e.message
      retry
    end

    begin #destination input
      print "Enter destination of piece: "
      finish_str = gets.chomp

      valid_position_input?(finish_str)
      finish = translate_input(finish_str)

      #if end_pos is in moves-list for piece.

      unless self.board[start].valid_moves.include?(finish) #valid move?
        raise RuntimeError.new("Invalid input: Piece cannot go there.")
      end

    rescue RuntimeError => e
      puts e.message
      retry
    end

    captured = self.board[finish]
    self.board.move(start, finish) # Ok, move can actually occur.

    if captured.is_a?(Piece)
      puts "#{captured.color.to_s.capitalize} #{captured.class.to_s} has been captured!"
    end

    puts "You moved #{piece.class.to_s} from #{start_str} to #{finish_str}"
  end

  def promo_choice
    begin
      puts "Your pawn has reached the far side! You may promote it to a: "
      puts "Queen (Q), Rook (R), Bishop (B), or Knight (N)."
      print "Select a piece: "
      input = gets.chomp.upcase
      raise RuntimeError.new("Invalid choice.") unless %w[Q R B N].include?(input)
    rescue RuntimeError => e
      puts e.message
      retry
    end

    piece_choice = { 'Q'=> Queen, 'R' => Rook, 'B' => Bishop, 'N' => Knight }
    return piece_choice[input]
  end

  private
  def translate_input(input)
    col = input[0].ord - 'a'.ord
    row = 8 - input[1].to_i
    [row, col]
  end

end