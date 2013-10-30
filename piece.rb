class Piece
  attr_accessor :color, :position, :board

  CARDINAL_DELTAS = [[ 1, 0], # Right
                     [-1, 0], # Left
                     [ 0, 1], # Down
                     [ 0,-1]] # Up

  DIAGONAL_DELTAS = [[ 1, 1], # DownRight
                     [ 1,-1], # UpRight
                     [-1, 1], # DownLeft
                     [-1,-1]] # UpLeft

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def dup(board = self.board)
    return self.class.new(self.color, self.position, board)
  end

  def move_into_check?(pos)
    dup_board = self.board.dup
    dup_board.move!(self.position, pos)
    dup_board.checked?(self.color)
  end

  def valid_moves
    moves.select { |move| !move_into_check?(move) }
  end

  def valid_move?(start,finish)
    #to do, possibly help refactor HumanPlayer class
  end

  private
  def moves
    raise NotImplementedError.new("Override moves in child") # Override in child
  end
end

class SlidingPiece < Piece
  def moves
    # Given a position on the board, my allowed moves are
    # all the valid positions in the direction of move_dirs
    moves = []
    deltas = move_dirs
    # p "deltas: #{deltas}"

    deltas.each do |delta|
      # p "delta: #{delta}"
      pos = [self.position[0] + delta[0], self.position[1] + delta[1]]
      # p "first pos in direction: #{pos}"

      # Add all empty spaces up to an occupied square
      while self.board.in_bounds?(pos) && self.board[pos].nil?
        moves << pos
        # p "moves is now: #{moves}"
        pos = pos.dup
        pos[0] = (pos[0] + delta[0])
        pos[1] = (pos[1] + delta[1])
        # p "pos: #{pos}"
        #break unless self.board.in_bounds?(pos) && self.board[pos].nil?
      end

      # Add occupied square if it is an enemy (you can capture!)
      moves << pos if self.board.in_bounds?(pos) && !self.board[pos].nil? && self.board[pos].color != self.color
    end

    moves
  end

  private
  def move_dirs
    raise NotImplementedError("Override move_dirs in child") # Override in child
  end
end


class Queen < SlidingPiece
  private
  def move_dirs
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end


  def to_s

  end

end

class Rook < SlidingPiece
  private
  def move_dirs
    CARDINAL_DELTAS
  end
end

class Bishop < SlidingPiece
  private
  def move_dirs
    DIAGONAL_DELTAS
  end
end



class SteppingPiece < Piece
  def moves
    deltas = move_dirs
    moves = []

    deltas.each do |delta|
      pos = [self.position[0] + delta[0], self.position[1] + delta[1]]
      if self.board.in_bounds?(pos) && (self.board[pos].nil? || self.board[pos].color != self.color)
        moves << pos
      end
    end

    moves
  end

  private
  def move_dirs
    raise NotImplementedError("Override move_dirs in child") # Override in child
  end
end

class Knight < SteppingPiece

  KNIGHT_DELTAS =   [[ 2, 1],
                     [ 2,-1],
                     [-2, 1],
                     [-2,-1],
                     [ 1, 2],
                     [ 1,-2],
                     [-1, 2],
                     [-1,-2]]

  private
  def move_dirs
    KNIGHT_DELTAS
  end
end

class King < SteppingPiece
  private
  def move_dirs
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end



class Pawn < Piece

  def moves
    pos = self.position
    moves = []

    #change direction depending on color (+1 for black, -1 for white)
    i = (self.color == :black ? 1 : -1)
    start_row = (self.color == :black ? 1 : 6)

    #pawn's basic move is advancing one position forward so
    #long as it's not occupied
    normal_move = [pos[0]+i,pos[1]]
    if self.board[normal_move].nil? && self.board.in_bounds?(normal_move)
      moves << normal_move
    end

    #pawn can move 2 squares from starting square
    init_move = [pos[0] + (i*2), pos[1]]
    if pos[0] == start_row && self.board[init_move].nil? # Initial position
      moves << init_move
    end

    #pawn can only move diagonally one square if occupied by enemy piece
    capture_moves = [[pos[0]+i, pos[1]+1], [pos[0]+i, pos[1]-1]]
    capture_moves.each do |capture_move|
      if self.board.in_bounds?(capture_move) && !self.board[capture_move].nil?
        moves << capture_move if self.board[capture_move].color != self.color
      end
    end

    moves
  end
end





