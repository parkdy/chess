require "./board"
require "./piece"
require "./player"



class Game
  attr_accessor :board, :players


  def initialize
    @board = Board.new
    @board.set_pieces
    @players = [ HumanPlayer.new(:white, @board), HumanPlayer.new(:black, @board) ]
  end


  def play
    game_over = false
    until game_over

      self.players.each do |player|
        self.board.display
        if self.board.checked?(player.color)
          puts "WARNING: #{player.color.to_s.capitalize}'s King is in check!"
        end
        puts "#{player.color.to_s.capitalize} moves."
        player.play_turn

        #pawn promotion?
        pawn = self.board.pawn_to_be_promoted
        board.promote(pawn, player.color, player.promo_choice) unless pawn.nil?

        if self.board.checkmate?(player.color)
          game_over = true
          puts "Checkmate! #{player.color.to_s.capitalize} wins!"
          break
        end

      end
    end

    self.board.display
  end
end



if $PROGRAM_NAME == __FILE__
  Game.new.play
end