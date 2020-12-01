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

  def move_checks_self?(piece, location)
    starting_location = piece.location
    test_move_piece(piece, location)
    output = player_in_check?(piece.player) ? true : false
    test_move_piece(piece, starting_location)
    output
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
