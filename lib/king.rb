# frozen_string_literal: true

require_relative 'piece.rb'

class King
  include Piece

  def symbol(color)
    color == 'white' ? "\u2654".encode : "\u265A".encode
  end

  def can_attack_king?
    moves = uncleaned_moves(@location.first, @location.last)
    moves.include?(@game.enemy_king_location(@player)) ? true : false
  end

  def can_castle?(rook)
    if castle_pieces_moved?(rook) || castle_prevented_by_check?(rook)
      false
    else
      reachable?(self, rook.location, @game.board)
    end
  end

  def add_castle_move(rook, moves)
    castle_column = rook.location.last == 7 ? 6 : 2
    moves.push([location.first, castle_column]) if can_castle?(rook)
    moves
  end

  private

  def uncleaned_moves(row, column)
    modifiers = [1, 0, -1].product([1, 0, -1])
    apply_move_modifiers(modifiers, row, column)
  end

  def possible_moves(row, column)
    clean_moves(uncleaned_moves(row, column))
  end

  def castle_pieces_moved?(rook)
    @moved || rook.moved
  end

  def castle_prevented_by_check?(rook)
    rook_direction = rook.location.last == 7 ? 1 : -1
    toward_rook = [@location.first, @location.last + rook_direction]
    toward_rook_second_move = [toward_rook.first, (toward_rook.last + 1)]
    @game.player_in_check?(player) \
    || @game.move_checks_self?(self, toward_rook) \
    || @game.move_checks_self?(self, toward_rook_second_move)
  end
end
