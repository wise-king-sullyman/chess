# frozen_string_literal: true

require_relative 'piece'

class King
  include Piece

  attr_reader :location, :moved

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def can_attack_king?
    moves = uncleaned_moves(location.first, location.last)
    moves.include?(game.enemy_king_location(player)) ? true : false
  end

  def can_castle?(rook)
    if castle_pieces_moved?(rook) || castle_prevented_by_check?(rook)
      false
    else
      reachable?(self, rook.location, game.board)
    end
  end

  def add_castle_move(rook, moves)
    castle_column = rook.location.last == 7 ? 6 : 2
    moves.push([location.first, castle_column]) if can_castle?(rook)
    moves
  end

  def move_castling_rook(king_to_location)
    rook_column = king_to_location.last > 5 ? 7 : 0
    rook = game.board.piece_at([king_to_location.first, rook_column])
    rook_column_destination = rook.location.last == 7 ? 5 : 3
    rook.move([rook.location.first, rook_column_destination])
  end

  def move(to_location, test_move = false)
    columns_traversed = (to_location.last - location.last).abs
    move_castling_rook(to_location) unless columns_traversed < 2 || test_move
    self.location = to_location
    self.moved = true unless test_move
  end

  def uncleaned_moves(row, column)
    modifiers = [1, 0, -1].product([1, 0, -1])
    apply_move_modifiers(modifiers, row, column)
  end

  def possible_moves(row, column)
    moves = clean_moves(uncleaned_moves(row, column))
    player.pieces.each do |piece|
      add_castle_move(piece, moves) if piece.class == Rook
    end
    moves
  end

  def castle_pieces_moved?(rook, king_has_moved = moved)
    king_has_moved || rook.moved
  end

  def castle_prevented_by_check?(rook)
    rook_direction = rook.location.last == 7 ? 1 : -1
    toward_rook = [location.first, location.last + rook_direction]
    toward_rook_second_move = [toward_rook.first, (toward_rook.last + 1)]
    game.player_in_check?(player) \
    || game.move_checks_self?(self, toward_rook, game.board) \
    || game.move_checks_self?(self, toward_rook_second_move, game.board)
  end
end
