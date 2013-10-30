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
  def translate_input(input)
    col = input[0].ord - 'a'.ord
    row = 8 - input[1].to_i
    [row, col]
  end

  # Returns array with start and finish positions
  def play_turn
    begin
      prompt_msg = "Enter position of piece to move: "
      start_str = prompt(prompt_msg) do |input|
        puts "Invalid input: only 2 letters" unless input.length == 2
        puts "Invalid input: file must be a-h" unless input[0].between?('a','h')
        puts "Invalid input: rank must be 1-8" unless input[1].between?('1','8')
        valid = input.length == 2 && input[0].between?('a','h') && input[1].between?('1','8')

        start = translate_input(input)
        unless !self.board[start].nil? && self.board[start].color == self.color #board class
          puts "Invalid input: not your piece!"
        end
        valid &&= !self.board[start].nil? && self.board[start].color == self.color
      end
      start = translate_input(start_str)

      prompt_msg = "Enter destination of piece: "
      finish_str = prompt(prompt_msg) do |input|
        puts "Invalid input: only 2 letters" unless input.length == 2
        puts "Invalid input: file must be a-h" unless input[0].between?('a','h')
        puts "Invalid input: rank must be 1-8" unless input[1].between?('1','8')

        valid = input.length == 2 && input[0].between?('a','h') && input[1].between?('1','8')
      end

      finish = translate_input(finish_str)
      piece = self.board[start]
      captured = self.board.move(start, finish)

   rescue
      puts "Invalid move"
      retry
    end
    if captured.is_a?(Piece)
      puts "#{captured.color.to_s.capitalize} #{captured.class.to_s} has been captured!"
    end

    puts "You moved #{piece.class.to_s} from #{start_str} to #{finish_str}"
  end

end