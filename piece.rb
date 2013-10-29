class Piece
  attr_accessor :position, :board

  CARDINAL_DELTAS = [[ 1, 0], # Right
                     [-1, 0], # Left
                     [ 0, 1], # Down
                     [ 0,-1]] # Up

  DIAGONAL_DELTAS = [[ 1, 1], # DownRight
                     [ 1,-1], # UpRight
                     [-1, 1], # DownLeft
                     [-1,-1]] # UpLeft
  def moves
    raise NotImplementedError # Override in child
  end

  def move(new_pos)
    raise NotImplementedError # Override in child
  end
end

class SlidingPiece < Piece


  def moves
    # Given a position on the board, my allowed moves are
    # all the valid positions in the direction of move_dirs
    moves = []
    deltas = move_dirs

    deltas.each do |delta|
      pos = [self.position[0] + delta[0], self.position[1] + delta[1]]

      until @board.occupied_at?(pos) || !@board.in_bounds?(pos)
        moves << pos
        pos[0] += delta[0]
        pos[1] += delta[1]
      end

    moves
  end

  def move_dirs
    raise NotImplementedError # Override in child
  end
end


class Queen < SlidingPiece
  def move_dirs
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end

class Rook < SlidingPiece
  def move_dirs
    CARDINAL_DELTAS
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL_DELTAS
  end
end



class SteppingPiece < Piece
  def moves
    deltas = move_dirs
    moves = []

    deltas.each do |delta|
      unless @board.occupied_at?(pos) || !@board.in_bounds?(pos)
        moves << [self.position[0] + delta[0], self.position[1] + delta[1]]
    end

    moves
  end

  def move_dirs
    raise NotImplementedError # Override in child
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
  def move_dirs
    KNIGHT_DELTAS
  end
end

class King < SteppingPiece
  def move_dirs
    CARDINAL_DELTAS + DIAGONAL_DELTAS
  end
end



class Pawn < Piece
  # TO DO
end





