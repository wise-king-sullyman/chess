# frozen_string_literal: true

# Includes methods related to validation of moves
module MoveValidation
  def valid_move?(piece, location, board)
    piece.legal_move?(location) \
    && available?(piece.player, location, board) \
    && reachable?(piece, location, board)
  end

  def valid_moves(piece, location, board)
    possible_moves(location.first, location.last).select do |move|
      available?(piece.player, move, board) && reachable?(piece, move, board)
    end
  end

  def available?(player, location, board)
    at_location = board.piece_at(location)
    return false if at_location.respond_to?(:player) && at_location.player == player

    true
  end

  def reachable?(piece, destination, board)
    from_row = piece.location.first
    from_column = piece.location.last
    to_row = destination.first
    to_column = destination.last

    return true if piece.class == Knight

    return row_reachable?(piece, destination, board) if from_row == to_row

    return column_reachable?(piece, destination, board) if from_column == to_column

    return false unless diagonal_reachable?(piece, destination, board)

    true
  end

  def row_reachable?(piece, to, board)
    from_column = piece.location.last
    range = to.last > from_column ? (from_column + 1...to.last) : (to.last + 1...from_column)
    range.each do |column|
      return false if board.piece_at([piece.location.first, column])
    end
    true
  end

  def column_reachable?(piece, to, board)
    from_row = piece.location.first
    range = to.first > from_row ? (from_row + 1...to.first) : (to.first + 1...from_row)
    range.each do |row|
      return false if board.piece_at([row, piece.location.last])
    end
    true
  end

  private

  def diagonal_reachable?(piece, to, board)
    from_row = piece.location.first
    from_column = piece.location.last
    row_direction = from_row < to.first ? 1 : -1
    column_direction = from_column < to.last ? 1 : -1
    until from_row + row_direction == to.first && from_column + column_direction == to.last
      return false if board.piece_at([from_row += row_direction, from_column += column_direction])
    end
    true
  end
end
