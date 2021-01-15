# frozen_string_literal: true

# Includes methods for detecting check/checkmate
module CheckDetection
  def player_in_check?(player)
    enemy_in_check?(other_player(player))
  end

  def player_in_checkmate?(player)
    player_in_check?(player) && player.mated?
  end

  def enemy_in_check?(calling_player)
    calling_player.pieces.each do |piece|
      return true if piece.can_attack_king?
    end
    false
  end

  def move_checks_self?(piece, location, board)
    starting_location = piece.location
    piece_at_location = board.piece_at(location)
    test_move(piece, nil, location, board)
    output = player_in_check?(piece.player)
    test_move(piece, piece_at_location, starting_location, board)
    output
  end

  def test_move(piece, replace_piece_with, to_location, board)
    from_row, from_column = piece.location
    to_row, to_column = to_location
    piece.move(to_location, true)
    board.update(from_row, from_column, replace_piece_with)
    board.update(to_row, to_column, piece)
  end

  def in_check_at?(player, location)
    enemy_pieces = other_player(player).pieces
    enemy_pieces.each do |piece|
      next if piece.class == King
      return true if piece.can_attack_location?(location)
    end
    false
  end
end
